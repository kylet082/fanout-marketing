def _as_str(value):
    return "" if value is None else str(value).strip()


validator = {
    "first_name": _as_str,
    "surname": _as_str,
    "dob": _as_str,
    "mobile_number": _as_str,
    "email_address": _as_str,
}


def validate(params):
    """Run each param through its validator. Missing values become ""."""
    return {key: validator[key](value) for key, value in params.items()}
