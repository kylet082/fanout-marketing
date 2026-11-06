import json
import os

import boto3
from botocore.exceptions import BotoCoreError, ClientError

from c_logger.service import get_logger

logger = get_logger(__name__)

# Fields the step function reads from the input. A missing one would fail the
# workflow later, so reject the request up front instead.
REQUIRED_FIELDS = ('company', 'fname', 'lname', 'email', 'mobile_number', 'birthday')

CORS_HEADERS = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Headers': 'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token',
    'Access-Control-Allow-Credentials': True,
    'Content-Type': 'application/json'
}


def lambda_handler(event, context):
    # The request body holds subscriber details, so only log it at DEBUG.
    logger.debug("Received request: %s", event)

    try:
        body = parse_body(event)
    except ValueError as e:
        logger.warning("Rejected request: %s", e)
        return build_response(400, {'status': 'error', 'message': str(e)})

    try:
        execution_arn = start_step_function(body)
    except (BotoCoreError, ClientError):
        logger.exception("Failed to start step function")
        return build_response(500, {'status': 'error', 'message': 'Could not start workflow'})

    logger.info("Started workflow for company '%s' (execution=%s)", body['company'], execution_arn)
    return build_response(200, {'status': 'success'})


def parse_body(event):
    """Return the request body as a dict. Raises ValueError if it's unusable."""
    try:
        body = json.loads(event.get('body') or '')
    except ValueError:
        raise ValueError("Request body must be valid JSON")

    if not isinstance(body, dict):
        raise ValueError("Request body must be a JSON object")

    missing = [field for field in REQUIRED_FIELDS if not body.get(field)]
    if missing:
        raise ValueError("Missing required fields: {}".format(', '.join(missing)))

    return body


def start_step_function(payload):
    client = boto3.client('stepfunctions')
    response = client.start_execution(
        stateMachineArn=os.environ['STEP_FUNCTION_ARN'],
        input=json.dumps(payload)
    )
    return response['executionArn']


def build_response(status_code, body):
    return {
        'statusCode': status_code,
        'headers': CORS_HEADERS,
        'body': json.dumps(body)
    }
