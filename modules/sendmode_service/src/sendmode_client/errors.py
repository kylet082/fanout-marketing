class SendmodeError(Exception):
    """Raised when the Sendmode API returns a non-2xx response.

    The class name becomes the Step Functions error name, so the workflow can
    match on it. `status` holds the HTTP status code.
    """

    def __init__(self, message, status=None):
        super().__init__(message)
        self.status = status
