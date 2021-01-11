from functools import partial

def validator(item, value):
    print("validating")
    return {
        "first_name": __name,
        "surname": __surname,
        "dob": __dob,
        "mobile_number": __mobile_number
        # "email": __email
    }.get(item, value)


def __name(value):
    print("val name" + value)
    a = value
    return a

def __surname(value):
    print("val name" + value)
    return value

def __dob(value):
    print("val dob")
    return value


def __mobile_number(value):
    print("val mobile num")
    return value


def __email(value):
    print("val email" + value)
    return value
