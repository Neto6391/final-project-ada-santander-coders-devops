import json
import os
import boto3

def lambda_handler(event, context):
    sns_client = boto3.client('sns')
    
    SNS_TOPIC_ARN = os.environ.get('SNS_TOPIC_ARN')
    
    try:
        for record in event['Records']:
            message_body = json.loads(record['body'])
            
            sns_message = {
                'default': json.dumps({
                    'filename': message_body['filename'],
                    'num_lines': message_body['num_lines'],
                    'status': message_body['status']
                })
            }
            
            sns_client.publish(
                TopicArn=SNS_TOPIC_ARN,
                Message=json.dumps(sns_message),
                MessageStructure='json'
            )
        
        return {
            'statusCode': 200,
            'body': json.dumps({
                'message': 'Notificação enviada com sucesso'
            })
        }
    
    except Exception as e:
        print(f"Erro: {str(e)}")
        return {
            'statusCode': 500,
            'body': json.dumps({
                'message': 'Erro ao enviar notificação',
                'error': str(e)
            })
        }