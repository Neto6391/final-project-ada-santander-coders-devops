import json
import os
import random
import uuid
import boto3
import logging
from io import BytesIO


logging.basicConfig(level=logging.ERROR)
logger = logging.getLogger()

def generate_random_file_lines(max_lines=100):

    lines = []
    for _ in range(random.randint(10, max_lines)):
        lines.append(f"Data: {uuid.uuid4()}, Random: {random.random()}")
    return lines

def upload_file_to_s3(bucket_name, key, lines):
    s3_client = boto3.client('s3')
    
    try:
        file_obj = BytesIO("\n".join(lines).encode("utf-8"))
        s3_client.upload_fileobj(
            file_obj, 
            bucket_name, 
            key,
            ExtraArgs={'ContentType': 'text/plain'}
        )
    except Exception as e:
        logger.error(f"S3 Upload Error: {e}")
        raise

def lambda_handler(event, context):
    BUCKET_NAME = os.environ.get('BUCKET_NAME')
    
    if not BUCKET_NAME:
        return {
            'statusCode': 500,
            'body': json.dumps({'message': 'BUCKET_NAME not configured'})
        }
    
    try:
        filename = f"{uuid.uuid4()}.txt"
        lines = generate_random_file_lines(max_lines=50)
        
        upload_file_to_s3(BUCKET_NAME, filename, lines)
        
        return {
            'statusCode': 200,
            'body': json.dumps({
                'message': 'File generated successfully',
                'filename': filename,
                'lines': len(lines)
            })
        }
    except Exception as e:
        logger.error(f"Processing Error: {e}")
        return {
            'statusCode': 500,
            'body': json.dumps({'message': 'Processing failed', 'error': str(e)})
        }