import json
import os
import boto3
from sqlalchemy import create_engine, Column, Integer, String
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker

Base = declarative_base()

class FileMetadata(Base):
    __tablename__ = 'file_metadata'
    id = Column(Integer, primary_key=True, autoincrement=True)
    filename = Column(String(255), nullable=False)
    num_lines = Column(Integer, nullable=False)

def get_database_connection():
    DB_USERNAME = os.environ.get('DB_USERNAME')
    DB_PASSWORD = os.environ.get('DB_PASSWORD')
    DB_HOST = os.environ.get('DB_HOST')
    DB_NAME = os.environ.get('DB_NAME')
    
    connection_string = f"postgresql://{DB_USERNAME}:{DB_PASSWORD}@{DB_HOST}/{DB_NAME}"
    engine = create_engine(connection_string)
    return engine

def lambda_handler(event, context):
    s3_client = boto3.client('s3')
    sns_client = boto3.client('sns')
    
    SNS_TOPIC_ARN = os.environ.get('SNS_TOPIC_ARN')
    
    try:
        for record in event['Records']:
            bucket = record['s3']['bucket']['name']
            filename = record['s3']['object']['key']
            
            local_file_path = f"/tmp/{filename}"
            s3_client.download_file(bucket, filename, local_file_path)
            
            with open(local_file_path, 'r') as f:
                num_lines = sum(1 for _ in f)
            
            engine = get_database_connection()
            Base.metadata.create_all(engine)
            Session = sessionmaker(bind=engine)
            session = Session()
            
            file_metadata = FileMetadata(
                filename=filename,
                num_lines=num_lines
            )
            session.add(file_metadata)
            session.commit()
            session.close()
            
            os.remove(local_file_path)
            
            sns_client.publish(
                TopicArn=SNS_TOPIC_ARN,
                Message=json.dumps({
                    'filename': filename,
                    'num_lines': num_lines,
                    'status': 'Processado com sucesso'
                }),
                Subject='Processamento de Arquivo Concluído'
            )
        
        return {
            'statusCode': 200,
            'body': json.dumps({
                'message': 'Arquivo processado com sucesso'
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