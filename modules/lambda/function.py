#The Lambda function that will take the value and increment it +1
import os 
import json
import boto3

dynamodb = boto3.resource('dynamodb')

#Environment variables derived from the DynamoDB module
table_name = os.environ['DYNAMODB_TABLE_NAME']
table_hashkey = os.environ['DYNAMODB_TABLE_HASHKEY']
item_json = os.environ['DYNAMODB_ITEM_NAME']
item_data = json.loads(item_json)

table = dynamodb.Table(table_name)

def increment_visitor_count():
    response = table.update_item(
        Key= {
            table_hashkey : item_data['ID']['S']
        },
        UpdateExpression='SET #v = #v + :val',
        ExpressionAttributeNames={
            '#v':'Value'
        },
        ExpressionAttributeValues={':val': 1}
    )
    

def get_visitor_count():
    response = table.get_item(
        Key= {
            table_hashkey : item_data['ID']['S']
            }
        )
    # Converting the Value into a FLOAT otherwise, we wont be able to turn it into json format below
    item = response.get('Item')
    if item:
        item['Value'] = float(item['Value'])
    return response
    

def lambda_handler(event, context):
    
    increment_visitor_count()
    response= get_visitor_count()
    response_body = json.dumps(response['Item'])
    
   
    return {
        'statusCode': 200,
        'headers': {
            'Content-Type': 'application/json'
        },
        'body': response_body
    }