import logging

def get_logger(name, level=None):
    logger = logging.getLogger(name)
    level = logging.INFO if level is None else level
    logger.setLevel(level)
    formatter = logging.Formatter('{msecs:03.3f}:{levelname}:{message}', style='{')
    root = logging.getLogger()
    for h in root.handlers:
        h.setFormatter(formatter)

    return logger
