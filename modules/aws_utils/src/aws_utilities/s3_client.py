from boto3 import client


class S3Client(object):
    s3_client = None

    def __init__(self):
        self.s3_client = client('s3')

    def get_object(self, bucket, path):
        obj = self.s3_client.get_object(Bucket=bucket, Key=path)
        body = obj['Body']
        return body.read()

    def get_object_content(self, bucket, path):
        raw_content = self.get_object(bucket, path)
        return raw_content.decode("utf-8")