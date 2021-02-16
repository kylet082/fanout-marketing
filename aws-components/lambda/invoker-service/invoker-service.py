import os
import json
import boto3
from c_logger.service import get_logger

logger = get_logger(__name__)

def lambda_handler(event, context):
    logger.info('Recieved request : ' + str(event))
    body = json.loads(event['body'])

    start_step_function(body)

    return {'statusCode': 200,
    'headers': {
        'Access-Control-Allow-Origin' : '*',
        'Access-Control-Allow-Headers':'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token',
        'Access-Control-Allow-Credentials' : True,
        'Content-Type': 'application/json'
        }
    }


def start_step_function(input):
    step_function_arn = os.environ['STEP_FUNCTION_ARN']
    client = boto3.client('stepfunctions')
    response = client.start_execution(
        stateMachineArn=step_function_arn,
        input=json.dumps(input)
    )

    logger.info('Response : ' + str(response))



def status_mapper():
    # TODO : Add response validations here
    print("mapping status")