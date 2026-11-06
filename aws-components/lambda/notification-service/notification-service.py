import json
import os

import boto3

from c_logger.service import get_logger

logger = get_logger(__name__)


def lambda_handler(event, context):
    # The body holds subscriber details, so only log it at DEBUG.
    logger.debug("Received event: %s", event)
    subject = event['subject']
    body = format_json(event['body'])

    sns_arn = os.environ['EMAIL_SNS_ARN']

    return publish_topic(subject, body, sns_arn)


def format_json(data):
    return json.dumps(data, indent=4, sort_keys=True)


def publish_topic(subject, body, sns_arn):
    sns = boto3.client('sns')

    response = sns.publish(
        TopicArn=sns_arn,
        Subject=subject,
        Message=body
    )

    logger.info("Published notification '%s' (message id=%s)", subject, response.get('MessageId'))

    return True
