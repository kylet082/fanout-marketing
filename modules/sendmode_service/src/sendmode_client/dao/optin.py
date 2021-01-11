from ..http.client import HTTPClient
from ..utils.vaildation import validator
import json

from c_logger.service import get_logger

logger = get_logger(__name__)

class OptIn(object):

    url = "/v2/import"

    def __init__(self, mobile_number, first_name, email, dob, surname=None,
                 address=None, town=None, county=None):
        self.mobilenumber = mobile_number
        self.firstname = first_name
        self.surname = surname
        self.address = address,
        self.town = town
        self.county = county
        self.email = email
        self.dateofbirth = dob

    def submit_optin(self, http_client: HTTPClient, group):
        # params = self.__validate_params()
        contents = {
            "mobilenumber": self.mobilenumber,
            "firstname": self.firstname,
            "surname": self.surname,
            "dateofbirth": self.dateofbirth,
            "email": self.email
        }

        c = json.dumps(contents)
        body = {
            "group": group,
            "importdata": c
        }
        header = {"Content-Type": "application/x-www-form-urlencoded; charset=UTF-8"}

        response = http_client.post_method(self.url, header, body)
        logger.info("Sendmode Optin response : " + str(response.getcode()))

        return response


    def __validate_params(self):
        params = vars(OptIn)
        for key in params:
            if not params[key]:
                del params[key]
            # else:
            #     params[key] = validator(key, params[key])
        return params

