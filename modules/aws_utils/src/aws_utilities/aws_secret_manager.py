import boto3
from botocore.exceptions import ClientError
import json
from c_logger.service import get_logger

logger = get_logger(__name__)
# TODO : add default logger here

def get_aws_secret(secret_name):
    secret_manager = boto3.client('secretsmanager')
    try:
        response = secret_manager.get_secret_value(
            SecretId=secret_name
        )
    except ClientError as e:
        error_code =e.repsonse['Error']['Code']
        if error_code == 'InternalServiceErrorException':
            logger.error("Secret Manager can't decrypt the protected secret with provided KMS")
            raise e
        elif error_code == 'InvalidParameterException':
            logger.error("Server side Error!!")
            raise e
        elif error_code == 'InvalidRequestException':
            logger.error("Provided Parameter value is not valid")
            raise e
        elif error_code == 'ResourceNotFoundException':
            logger.error("Can't find the secret resource")
            raise e
        else:
            logger.error("Can't retrieve the secret from Secret Manager")
            raise e

    return json.loads(response['SecretString'], strict=False)
