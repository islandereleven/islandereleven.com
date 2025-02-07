import os 
import json 
import boto3 
import re 
from botocore.exceptions import ClientError   


s3 = boto3.client('s3') 
BUCKET_NAME = os.environ['S3_BUCKET_NAME'] 
GOLD_TIER_PREFIX = "gold/" # From your data lake structure   # Approved chart mappings (could also store in SSM Parameter Store) 
CHART_MAPPING = { "tizc": "charts/time_in_zone_chart.json" }   


def lambda_handler(event, context): 
    try: # Get chart ID from query parameters 
        chart_id = event.get('queryStringParameters', {}).get('chart_id')

        # Validate input  
        if not chart_id or not re.match(r'^[a-zA-Z0-9_\-]+$', chart_id):  
            return {  
                'statusCode': 400,  
                'body': json.dumps({'error': 'Invalid or missing chart_id parameter'})  
            }  

        # Map to actual S3 key  
        s3_key = CHART_MAPPING.get(chart_id)  
        if not s3_key:  
            return {  
                'statusCode': 404,  
                'body': json.dumps({'error': 'Chart not found'})  
            }  

        # Construct full path with validation  
        full_path = f"{GOLD_TIER_PREFIX}{s3_key}"  
        if '..' in full_path or not full_path.startswith(GOLD_TIER_PREFIX):  
            return {  
                'statusCode': 400,  
                'body': json.dumps({'error': 'Invalid path construction'})  
            }  

        # Get object from S3  
        response = s3.get_object(Bucket=BUCKET_NAME, Key=full_path)  
        data = response['Body'].read().decode('utf-8')  
        
        return {  
            'statusCode': 200,  
            'headers': {  
                'Content-Type': 'application/json',  
                'Access-Control-Allow-Origin': '*'  
            },  
            'body': data  
        }  
        
    except ClientError as e:  
        return {  
            'statusCode': 404,  
            'body': json.dumps({'error': 'Resource not found'})  
        }  
    except Exception as e:  
        return {  
            'statusCode': 500,  
            'body': json.dumps({'error': f'Internal server error {e}'})  
        }  