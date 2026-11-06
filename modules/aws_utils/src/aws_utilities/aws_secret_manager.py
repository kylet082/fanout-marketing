import json

import boto3
from botocore.exceptions import ClientError

from c_logger.service import get_logger

logger = get_logger(__name__)

_ERROR_MESSAGES = {
    'DecryptionFailure': "Secrets Manager can't decrypt the secret with the provided KMS key",
    'InternalServiceError': "Secrets Manager server-side error",
    'InvalidParameterException': "Provided parameter value is not valid",
    'InvalidRequestException': "Request is not valid for the current state of the secret",
    'ResourceNotFoundException': "Can't find the secret resource",
}


def get_aws_secret(secret_name):
    secret_manager = boto3.client('secretsmanager')
    try:
        response = secret_manager.get_secret_value(SecretId=secret_name)
    except ClientError as e:
        error_code = e.response['Error']['Code']
        message = _ERROR_MESSAGES.get(error_code, "Can't retrieve the secret from Secrets Manager")
        logger.error("%s (code=%s, secret=%s)", message, error_code, secret_name)
        raise

    return json.loads(response['SecretString'], strict=False)
