from http.client import HTTPSConnection
from http.client import HTTPException
from http.client import HTTPS_PORT
import urllib

from c_logger.service import get_logger

logger = get_logger(__name__)

class HTTPClient(object):
    DEFAULT_HOST = "rest.sendmode.com"
    conn = None

    def __init__(self, host=None, headers=None):
        if headers is None:
            headers = dict()
        if host is None:
            host = self.DEFAULT_HOST
        self.host = host
        self.headers = headers

    def connect(self):
        try:
            self.conn = HTTPSConnection(self.host, port=HTTPS_PORT)
        except HTTPException as e:
            raise e
        return self

    def auth(self, access_token):
        self.headers = {"Authorization": access_token}
        return self

    def post_method(self, url, headers, body):
        method = "POST"
        header = {**headers, **self.headers}
        try:
            self.conn.request(method, url, self.__build_payload(body) , header)
        except HTTPException as e:
            self.__close()
            raise e
        response = self.conn.getresponse()
        self.__close()

        return response

    def __close(self):
        self.conn.close()

    def __build_payload(self, raw_payload):
        return urllib.parse.urlencode(raw_payload)
