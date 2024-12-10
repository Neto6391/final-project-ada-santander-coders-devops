# Infraestrutura Automatizada para a ADA Contabilidade

## Visão Geral
Este projeto tem como objetivo criar uma infraestrutura em nuvem segura, escalável e automatizada para a ADA Contabilidade, utilizando a AWS (Amazon Web Services) e o Terraform. A infraestrutura foi projetada para suportar operações contábeis e financeiros, oferecendo uma base robusta para aplicativos e serviços. Com o uso de Terraform, a infraestrutura pode ser facilmente replicada, modificada e escalada de forma ágil.

## Objetivos do Projeto
A ADA Contabilidade está implementando uma solução que visa:

1. **Escalabilidade e Flexibilidade**: Permitir a expansão conforme a demanda aumenta, utilizando serviços da AWS que podem ser facilmente ajustados.
2. **Segurança**: Garantir que os dados da contabilidade sejam acessíveis somente por usuários autorizados, com controle de acesso rigoroso e monitoramento contínuo.
3. **Alta Disponibilidade**: Construir a infraestrutura para garantir que os serviços permaneçam disponíveis e resilientes, mesmo em caso de falhas.
4. **Automação**: Automatizar a criação e gerenciamento de recursos da AWS, utilizando Terraform para provisionar a infraestrutura, tornando o processo mais rápido e sem erros humanos.

## Arquitetura da Infraestrutura
A infraestrutura é composta pelos seguintes componentes principais:

1. **VPC (Virtual Private Cloud)**: A VPC foi configurada com sub-redes privadas e públicas, utilizando CIDR blocks distribuídos para garantir uma separação de rede eficiente.
2. **Sub-redes**: As sub-redes privadas são utilizadas para ambientes internos, enquanto as sub-redes públicas são usadas para recursos como NAT Gateway e Internet Gateway.
3. **NAT Gateway**: Usado para permitir que instâncias em sub-redes privadas acessem a internet sem expor seus IPs diretamente à internet.
4. **Endpoints de VPC**: O acesso aos serviços como S3, SQS, SNS e DynamoDB é feito através de endpoints de VPC, garantindo segurança adicional, sem tráfego de dados na internet.
5. **Security Groups**: Definem regras de firewall para controlar o tráfego de entrada e saída dos recursos dentro da VPC.
6. **DynamoDB**: A base de dados NoSQL DynamoDB foi configurada para armazenar dados de contabilidade, com índices secundários globais para facilitar consultas específicas.
7. **Terraform**: Utilizado para automatizar o gerenciamento de toda a infraestrutura, garantindo que todos os recursos sejam configurados de forma padronizada e sem a necessidade de intervenção manual.

## Estrutura do Projeto
```
.
├── lambdas/
│   ├── generate_file/               # Lambda para gerar um arquivo txt aleatório
|   |   ├── lambda_handler.py               # Arquivo da lambda
|   |   └── requirements.txt               # Dependencias da lambda
│   ├── notify_user/               # Lambda para disparar email para usuário
|   |   ├── lambda_handler.py               # Arquivo da lambda
|   |   └── requirements.txt               # Dependencias da lambda
│   └── process_file/             # Script gerador de um txt aleatório
|   |   ├── lambda_handler.py               # Arquivo da lambda
|   |   └── requirements.txt # Dependencias da lambda
├── scripts/
│   └── package-lambdas.sh               # Script para empacotar as lambdas
├── terraform/
│   ├── modules/               # Módulos do Terraform
|   |   ├── dynamodb/               # Módulo do DynamoDB
|   |   ├── lambda/               # Módulos da lambda
|   |   ├── s3/               # Módulos do S3
|   |   ├── sns/               # Módulos do SNS
|   |   ├── sqs/               # Módulos do SQS
|   |   └── vpc/               # Módulos do VPC
│   ├── main.tf            # Principal da Lambda
│   ├── terraform.tfvars              # Variaveis do Terraform em tempo de execução
│   └── variables.tf               # Variaveis do Terraform
└── README.md
```

## Componentes

### Aplicação (`app/`)
- `main.py`: Gera arquivos CSV com dados aleatórios
- `lambda_function.py`: Processa arquivos e salva metadados no RDS
- `lambda_function.zip`: Pacote deployável da função Lambda

### Infraestrutura (`terraform/`)
- VPC com subnets públicas e privadas
- DynamoDB para armazenamento de dados
- Lambda Function para processamento
- S3 Bucket para armazenamento de arquivos
- SNS/SQS para mensageria
- Security Groups para controle de acesso

## Pré-requisitos
- AWS CLI configurado
- Terraform v1.6.0 ou superior
- Python 3.8 ou superior
- Conta AWS com permissões necessárias

## Funcionamento
1. Script Python gera arquivo txt com dados aleatórios
2. Arquivo é enviado para S3 automaticamente
3. Upload aciona Lambda de Processamento para processar o arquivo
4. Mensagem é enviada para fila SQS após o processamento ser concluído
6. Metadados são salvos no DynamoDB

## Segurança
- VPC privada para recursos críticos
- Security Groups específicos para cada componente
- IAM Roles com mínimo privilégio necessário

## Automação
- Upload automático de arquivos
- Processamento serverless via Lambda
- Notificações automáticas via SNS/SQS
- Infraestrutura como Código com Terraform


## Como Executar a Infraestrutura com Terraform

Para iniciar e aplicar a infraestrutura automatizada da ADA Contabilidade, siga os passos abaixo:

### 1. **Pré-requisitos**

Antes de executar o Terraform, certifique-se de que você tem os seguintes pré-requisitos:

- **Terraform instalado:** Caso ainda não tenha, baixe a versão mais recente do [Terraform](https://www.terraform.io/downloads.html) e siga as instruções para instalação.
  
- **Credenciais da AWS configuradas:** O Terraform precisa de credenciais da AWS para criar e gerenciar recursos. As credenciais podem ser configuradas de diferentes formas:
  - Utilizando o **AWS CLI**: Execute `aws configure` para fornecer as credenciais (chave de acesso e chave secreta).
  - Definindo as variáveis de ambiente `AWS_ACCESS_KEY_ID` e `AWS_SECRET_ACCESS_KEY`.
  - Utilizando um **role de IAM** se você estiver executando em uma instância EC2 ou no AWS CloudShell.

### 2. **Clonar o Repositório**

Se você ainda não tiver o repositório com os arquivos de Terraform, clone-o com o comando:

```bash
git clone https://github.com/Neto6391/final-project-ada-santander-coders-devops.git
cd terraform
```

### 3. **Inicializar o Terraform**

No diretório onde os arquivos de configuração do Terraform estão localizados, execute o comando para inicializar o Terraform:

```bash
terraform init
```

Esse comando irá inicializar o ambiente de trabalho do Terraform, baixar os plugins necessários e configurar o backend de estado.

### 4. **Verificar o Plano de Execução**

Antes de aplicar as mudanças, você pode executar um plano para ver o que será alterado na sua infraestrutura. Isso ajuda a verificar se tudo está correto:

```bash
terraform plan -var-file="terraform.tfvars"
```

O comando irá gerar um plano de execução que descreve as ações que o Terraform tomará para alcançar o estado desejado da infraestrutura.

### 5. **Aplicar as Mudanças**

Caso o plano esteja correto, execute o comando para aplicar a infraestrutura e criar os recursos definidos:

```bash
terraform apply -var-file="terraform.tfvars"
```

Quando executado, o Terraform irá mostrar um resumo das ações que serão realizadas. Você precisará confirmar com `yes` para proceder com a criação dos recursos.

### 6. **Verificar a Infraestrutura Criada**

Após a execução bem-sucedida do Terraform, você pode verificar se os recursos foram criados corretamente acessando o [Console da AWS](https://aws.amazon.com/console/).

### 7. **Gerenciar a Infraestrutura**

Se for necessário atualizar a infraestrutura, faça as alterações desejadas nos arquivos de configuração Terraform (por exemplo, em `main.tf`, `variables.tf`, ou `outputs.tf`), e depois execute:

```bash
terraform plan
terraform apply
```

Isso aplicará as mudanças e atualizará a infraestrutura de acordo com as novas configurações.

### 8. **Destruir a Infraestrutura**

Se você precisar destruir a infraestrutura, por exemplo, ao terminar os testes ou quando não precisar mais dos recursos, execute o comando:

```bash
terraform destroy
```

Esse comando irá excluir todos os recursos que foram criados, para garantir que você não acumule custos desnecessários na AWS.

## Autor
José Rodrigues

## Licença
Este projeto está sob a licença MIT.