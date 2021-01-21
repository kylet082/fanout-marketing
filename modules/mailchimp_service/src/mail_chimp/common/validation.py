from functools import partial

def __name(value):
    print("val name" + value)
    return str(value)

def __surname(value):
    print("val name" + value)
    return str(value)

def __dob(value):
    print("val dob")
    return str(value)

def __mobile_number(value):
    print("val mobile num")
    return value

def __email(value):
    print("val email" + value)
    return value



validator = {
    "first_name": __name,
    "surname": __surname,
    "dob": __dob,
    "mobile_number": __mobile_number,
    "email_address": __email
    }
