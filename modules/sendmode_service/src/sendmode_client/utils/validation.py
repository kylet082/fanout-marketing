def __dob(value):
    return value

def __mobile_number(value):
    return value

def __email(value):
    return value

def __first_name(value):
    return value

def __surname(value):
    if value == None:
        value = ""
    return value

def __address(value):
    if value == None:
        value = ""
    return value

def __town(value):
    if value == "":
        value = None
    return value

def __county(value):
    if value == None:
        value = ""
    return value


validator = {
    "first_name": __first_name,
    "surname": __surname,
    "address": __address,
    "town" : __town,
    "county": __county,
    "dob": __dob,
    "mobile_number": __mobile_number,
    "email": __email
}