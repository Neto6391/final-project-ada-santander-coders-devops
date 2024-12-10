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

## Benefícios da Infraestrutura Automatizada
1. **Escalabilidade Automática**: Com a infraestrutura provisionada automaticamente, a ADA Contabilidade pode facilmente expandir os recursos à medida que cresce, adicionando novas instâncias ou ajustando a capacidade da rede de forma ágil e sem downtime.
2. **Segurança Reforçada**: A segurança foi um fator chave no design da infraestrutura. Ao usar sub-redes privadas, endpoints VPC e controle rigoroso de acesso com security groups, a infraestrutura oferece proteção contra acessos não autorizados e reduz a superfície de ataque.
3. **Maior Eficiência Operacional**: A automação traz uma redução significativa no tempo de provisionamento de novos recursos e elimina a necessidade de intervenções manuais. Com o Terraform, a infraestrutura pode ser reconstruída ou alterada de forma rápida e sem erros.
4. **Controle de Custos**: A infraestrutura foi projetada para ser eficiente em termos de custo. Com a utilização de recursos como o NAT Gateway, S3 e DynamoDB, a ADA Contabilidade pode otimizar o uso dos serviços da AWS e evitar gastos desnecessários.
5. **Facilidade de Manutenção**: A infraestrutura é modular e reutilizável. Novos ambientes ou configurações podem ser criados com facilidade, mantendo consistência em todas as instâncias de deployment.

## O que Pode Ser Melhorado
Embora a infraestrutura tenha sido construída para ser eficiente e escalável, há sempre espaço para melhorias. Algumas áreas a serem consideradas para aprimoramento incluem:

1. **Monitoramento e Alertas**: Adicionar serviços de monitoramento como o CloudWatch para rastrear o desempenho da infraestrutura e enviar alertas sobre problemas, como instâncias sobrecarregadas ou falhas nos endpoints.
2. **Gerenciamento de Configuração**: Melhorar o gerenciamento de configurações, utilizando ferramentas como AWS Systems Manager para garantir que todas as instâncias estejam configuradas conforme os padrões de segurança e operacionais.
3. **Escalabilidade Automática**: Implementar escalabilidade automática para instâncias de EC2, o que permitiria ajustar dinamicamente a capacidade das máquinas com base na carga.
4. **Backup e Recuperação**: Melhorar a estratégia de backup para bancos de dados e outros recursos críticos, garantindo uma recuperação rápida e eficaz em caso de falhas.
5. **Documentação e Treinamento**: A documentação e treinamento contínuos para as equipes de TI garantirão uma gestão mais eficiente e a capacidade de realizar modificações na infraestrutura conforme a empresa cresce.

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
