import logging
import os

# aws_request_id is set by the Lambda runtime's log filter, so every line can be
# traced back to a single invocation. It falls back to "-" when run locally.
LOG_FORMAT = '%(asctime)s %(levelname)s %(aws_request_id)s [%(name)s] %(message)s'


class _RequestIdDefault(logging.Filter):
    def filter(self, record):
        if not getattr(record, 'aws_request_id', None):
            record.aws_request_id = '-'
        return True


def get_logger(name, level=None):
    """Return a logger that writes in the project's standard format.

    The level comes from the `level` argument, then the LOG_LEVEL env var,
    then defaults to INFO. Personal data must only be logged at DEBUG.
    """
    root = logging.getLogger()
    # Lambda attaches a handler to the root logger. Locally there is none,
    # so add one or INFO messages would be dropped.
    if not root.handlers:
        root.addHandler(logging.StreamHandler())

    formatter = logging.Formatter(LOG_FORMAT)
    for handler in root.handlers:
        handler.setFormatter(formatter)
        if not any(isinstance(f, _RequestIdDefault) for f in handler.filters):
            handler.addFilter(_RequestIdDefault())

    logger = logging.getLogger(name)
    logger.setLevel(level or os.environ.get('LOG_LEVEL', 'INFO').upper())
    return logger
