import json
import argparse
from boto3 import client

s3_client = client('s3')

aws_store = "aws_store"
mailchimp = "mailchimp"
sendmode = "sendmode"

def arguments():
    parser = argparse.ArgumentParser()
    parser.add_argument("--mailchimp_id", required=True)
    parser.add_argument("--sendmode_group", required=True)
    parser.add_argument("--company_name", required=True)
    parser.add_argument("--aws_secret_name", required=True)
    parser.add_argument("--s3_bucket", required=True)
    parser.add_argument("--s3_key", required=True)

    return parser.parse_args()


def get_config(bucket, key):
    obj = s3_client.get_object(Bucket=bucket, Key=key)
    body = obj['Body']
    raw = body.read().decode("utf-8")
    return json.loads(raw)

def upload_config(bucket, key, obj):
    json_str = json.dumps(obj)
    print(json_str)
    s3_client.put_object(Bucket=bucket, Key=key, Body=json_str.encode('utf-8'))

if __name__ == '__main__':
    args = arguments()
    json_obj = get_config(args.s3_bucket, args.s3_key)
    print(type(json))
    config = {
        "aws_store": args.aws_secret_name,
        "mailchimp": {
            "audience_id": args.mailchimp_id
        },
        "sendmode": {
            "group_id": args.sendmode_group
        }
    }

    json_obj[args.company_name] = config
    print(type(json_obj))
    upload_config(args.s3_bucket, args.s3_key, json_obj)
