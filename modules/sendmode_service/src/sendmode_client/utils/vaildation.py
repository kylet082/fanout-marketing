

def validator(item, value):
    print("validating")
    options = {
        "dob": __dob(value),
        "mobile_number": __mobile_number(value),
        "email": __email(value)
    }
    return options[item]()


def __dob(value):
    print("val dob")
    return value


def __mobile_number(value):
    print("val mobile num")
    return value


def __email(value):
    print("val email")
    return value