class MailChimpError(Exception):
    """Raised when the MailChimp API rejects a request.

    The class name becomes the Step Functions error name, so the workflow can
    match on it. `status` holds the HTTP status code, and `title` holds
    MailChimp's short error title (e.g. "Member Exists"), which contains no
    personal data.
    """

    def __init__(self, message, status=None, title=None):
        super().__init__(message)
        self.status = status
        self.title = title
