import json
import os
from aws_utilities.s3_client import S3Client
from c_logger.service import get_logger

"""
Example of Config :

{
 "acme_beauty" : {
    "aws_store" : "co/acme_beauty"
    "mailchimp": {
        "audience_id" : "120@ad213"
    },
    "sendmode" : {
        "group" : "my_test_group"
    }
 },
 "Company_name" : {
    ...
 }
}
"""

logger = get_logger(__name__)

def lambda_handler(event, context):
    s3_path = "{}/{}/config/config.json".format(event['workflow_type'], event['workflow_name'])
    s3_bucket = os.environ['S£_CODE_BUCKET']
    company = event['company']

    config = get_config(s3_bucket, s3_path)
    try:
        segment = config[company]
    except KeyError as e:
        print("stopping")
        raise e
    print(segment)
    return segment


def get_config(bucket, path):
    s3 = S3Client()
    content = s3.get_object_content(bucket, path)
    return json.loads(content)