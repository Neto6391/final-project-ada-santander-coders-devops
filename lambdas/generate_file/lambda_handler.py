import json
import os
import random
import time
import uuid
import boto3
import logging
from faker import Faker

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger()

def generate_random_file(max_lines=500):
    fake = Faker('pt_BR')
    num_lines = random.randint(50, max_lines)
    filename = f"{uuid.uuid4()}.txt"
    filepath = f"/dev/shm/{filename}"
    
    try:
        with open(filepath, 'w', encoding='utf-8') as f:
            for _ in range(num_lines):
                data_type = random.choice([
                    'pessoa', 'endereco', 'trabalho', 'texto', 'contato'
                ])
                linha = {
                    'pessoa': f"Nome: {fake.name()}, Idade: {fake.random_int(min=18, max=90)}, CPF: {fake.cpf()}",
                    'endereco': f"Endereço: {fake.street_address()}, Cidade: {fake.city()}, Estado: {fake.state()}",
                    'trabalho': f"Profissão: {fake.job()}, Empresa: {fake.company()}",
                    'texto': fake.paragraph(),
                    'contato': f"Email: {fake.email()}, Telefone: {fake.phone_number()}"
                }[data_type]
                f.write(f"{linha}\n")
        return filename, filepath, num_lines
    except IOError as e:
        logger.error(f"Erro ao criar arquivo: {e}")
        raise

def lambda_handler(event, context):
    s3_client = boto3.client('s3')
    BUCKET_NAME = os.environ.get('BUCKET_NAME')
    
    try:
        start_time = time.time()
        filename, filepath, num_lines = generate_random_file()
        s3_client.upload_file(filepath, BUCKET_NAME, filename)
        os.remove(filepath)
        
        logger.info(f"Arquivo {filename} gerado e enviado. Linhas: {num_lines}")
        return {
            'statusCode': 200,
            'body': json.dumps({
                'message': 'Arquivo gerado e enviado com sucesso',
                'filename': filename,
                'num_lines': num_lines,
                'execution_time': time.time() - start_time
            })
        }
    except Exception as e:
        logger.error(f"Erro no processamento: {e}")
        return {
            'statusCode': 500,
            'body': json.dumps({
                'message': 'Erro ao processar arquivo',
                'error': str(e)
            })
        }