import json
import os
import random
import boto3
import uuid
from faker import Faker

def generate_random_file():
    fake = Faker('pt_BR')
    num_lines = random.randint(100, 1000)
    filename = f"{uuid.uuid4()}.txt"
    filepath = f"/tmp/{filename}"

    with open(filepath, 'w', encoding='utf-8') as f:
        for _ in range(num_lines):
            data_type = random.choice([
                'pessoa',
                'endereco',
                'trabalho',
                'texto',
                'contato'
            ])
            
            if data_type == 'pessoa':
                linha = f"Nome: {fake.name()}, Idade: {fake.random_int(min=18, max=90)}, CPF: {fake.cpf()}"
            
            elif data_type == 'endereco':
                linha = f"Endereço: {fake.street_address()}, Cidade: {fake.city()}, Estado: {fake.state()}"
            
            elif data_type == 'trabalho':
                linha = f"Profissão: {fake.job()}, Empresa: {fake.company()}"
            
            elif data_type == 'texto':
                linha = fake.paragraph()
            
            else:
                linha = f"Email: {fake.email()}, Telefone: {fake.phone_number()}"
            
            f.write(f"{linha}\n")
    
    return filename, filepath, num_lines

def lambda_handler(event, context):
    s3_client = boto3.client('s3')

    BUCKET_NAME = os.environ.get('BUCKET_NAME')

    try:
        filename, filepath, num_lines = generate_random_file()
        s3_client.upload_file(filepath, BUCKET_NAME, filename)
        
        os.remove(filepath)

        return {
            'statusCode': 200,
            'body': json.dumps({
                'message': 'Arquivo gerado e enviado com sucesso',
                'filename': filename,
                'num_lines': num_lines
            })
        }

    except Exception as e:
        print(f"Erro: {str(e)}")
        return {
            'statusCode': 500,
            'body': json.dumps({
                'message': 'Erro ao processar arquivo',
                'error': str(e)
            })
        }