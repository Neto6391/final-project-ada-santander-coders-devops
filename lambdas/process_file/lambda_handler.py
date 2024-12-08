import json
import os
import boto3
from sqlalchemy import create_engine, Column, Integer, String
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from sqlalchemy.exc import SQLAlchemyError
import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger()

Base = declarative_base()

class FileMetadata(Base):
    __tablename__ = 'file_metadata'
    id = Column(Integer, primary_key=True, autoincrement=True)
    filename = Column(String(255), nullable=False)
    num_lines = Column(Integer, nullable=False)

class DatabaseConnectionCache:
    _engine = None
    
    @classmethod
    def get_engine(cls):
        if not cls._engine:
            try:
                DB_USERNAME = os.environ.get('DB_USERNAME')
                DB_PASSWORD = os.environ.get('DB_PASSWORD')
                DB_HOST = os.environ.get('DB_HOST')
                DB_NAME = os.environ.get('DB_NAME')
                
                connection_string = f"postgresql://{DB_USERNAME}:{DB_PASSWORD}@{DB_HOST}/{DB_NAME}"
                cls._engine = create_engine(
                    connection_string, 
                    pool_pre_ping=True, 
                    pool_recycle=3600,
                    connect_args={'connect_timeout': 5} 
                )
                Base.metadata.create_all(cls._engine)
            except Exception as e:
                logger.error(f"Erro de conexão com banco de dados: {e}")
                raise
        return cls._engine

def process_file(s3_client, filename, bucket, sns_client, SNS_TOPIC_ARN):
    local_file_path = f"/tmp/{filename}"
    
    try:
        s3_client.download_file(bucket, filename, local_file_path)
        
        with open(local_file_path, 'rb') as f:
            num_lines = sum(1 for _ in f)
        
        engine = DatabaseConnectionCache.get_engine()
        Session = sessionmaker(bind=engine)
        
        with Session() as session:
            file_metadata = FileMetadata(
                filename=filename,
                num_lines=num_lines
            )
            session.add(file_metadata)
            session.commit()
        
        sns_client.publish(
            TopicArn=SNS_TOPIC_ARN,
            Message=json.dumps({
                'filename': filename,
                'num_lines': num_lines,
                'status': 'Processado com sucesso'
            }),
            Subject='Processamento de Arquivo Concluído'
        )
        
        return num_lines
    
    except Exception as e:
        logger.error(f"Erro no processamento do arquivo {filename}: {e}")
        raise
    finally:
        try:
            os.remove(local_file_path)
        except FileNotFoundError:
            pass

def lambda_handler(event, context):
    s3_client = boto3.client('s3')
    sns_client = boto3.client('sns')
    
    SNS_TOPIC_ARN = os.environ.get('SNS_TOPIC_ARN')
    
    try:
        processed_files = []
        
        for record in event.get('Records', []):
            bucket = record['s3']['bucket']['name']
            filename = record['s3']['object']['key']
            
            num_lines = process_file(s3_client, filename, bucket, sns_client, SNS_TOPIC_ARN)
            processed_files.append({
                'filename': filename,
                'num_lines': num_lines
            })
        
        return {
            'statusCode': 200,
            'body': json.dumps({
                'message': 'Arquivos processados com sucesso',
                'processed_files': processed_files
            })
        }
    
    except Exception as e:
        logger.error(f"Erro global: {e}")
        
        return {
            'statusCode': 500,
            'body': json.dumps({
                'message': 'Erro ao processar arquivos',
                'error': str(e)
            })
        }