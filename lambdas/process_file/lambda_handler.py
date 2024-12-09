import json
import os
import boto3
import logging
from datetime import datetime
from typing import Dict, Any

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger()

s3_client = boto3.client('s3')
dynamodb = boto3.resource('dynamodb')
sns_client = boto3.client('sns')

def process_file(bucket: str, filename: str) -> Dict[str, Any]:
    try:
        local_file_path = f"/tmp/{filename}"
        s3_client.download_file(bucket, filename, local_file_path)
        
        with open(local_file_path, 'rb') as f:
            num_lines = sum(1 for _ in f)
        
        table_name = os.environ.get('DYNAMODB_TABLE')
        table = dynamodb.Table(table_name)
        
        item = {
            'file_id': filename,
            'filename': filename,
            'num_lines': num_lines,
            'processed_at': datetime.now().isoformat(),
            'status': 'Processed Successfully'
        }
        
        table.put_item(Item=item)
        
        sns_topic_arn = os.environ.get('SNS_TOPIC_ARN')
        if sns_topic_arn:
            sns_client.publish(
                TopicArn=sns_topic_arn,
                Message=json.dumps({
                    'filename': filename,
                    'num_lines': num_lines,
                    'status': 'Processed Successfully'
                }),
                Subject='File Processing Completed'
            )
        
        return {
            'filename': filename,
            'num_lines': num_lines,
            'status': 'Success'
        }
    
    except Exception as e:
        logger.error(f"Error processing file {filename}: {e}")
        raise
    finally:
        try:
            os.remove(local_file_path)
        except (FileNotFoundError, UnboundLocalError):
            pass

def lambda_handler(event, context):
    try:
        processed_files = []
        
        for record in event.get('Records', []):
            bucket = record['s3']['bucket']['name']
            filename = record['s3']['object']['key']
            
            result = process_file(bucket, filename)
            processed_files.append(result)
        
        return {
            'statusCode': 200,
            'body': json.dumps({
                'message': 'Files processed successfully',
                'processed_files': processed_files
            })
        }
    
    except Exception as e:
        logger.error(f"Global processing error: {e}")
        
        return {
            'statusCode': 500,
            'body': json.dumps({
                'message': 'Error processing files',
                'error': str(e)
            })
        }