from collections import namedtuple
from http.client import HTTPSConnection, HTTPS_PORT
from urllib.parse import urlencode

# The body is read before the connection closes, so callers can still use it.
Response = namedtuple('Response', ['status', 'reason', 'body'])


class HTTPClient(object):
    DEFAULT_HOST = "rest.sendmode.com"
    DEFAULT_TIMEOUT = 10  # seconds; keeps us well inside the lambda timeout

    def __init__(self, host=None, headers=None, timeout=DEFAULT_TIMEOUT):
        self.host = host or self.DEFAULT_HOST
        self.headers = dict(headers or {})
        self.timeout = timeout
        self.conn = None

    def connect(self):
        self.conn = HTTPSConnection(self.host, port=HTTPS_PORT, timeout=self.timeout)
        return self

    def auth(self, access_token):
        self.headers["Authorization"] = access_token
        return self

    def post_method(self, url, headers, body) -> Response:
        header = {**headers, **self.headers}
        try:
            self.conn.request("POST", url, urlencode(body), header)
            raw = self.conn.getresponse()
            return Response(raw.status, raw.reason, raw.read().decode('utf-8', errors='replace'))
        finally:
            self.conn.close()
