from ..http.client import HTTPClient
from ..utils.validation import validator
import json

from c_logger.service import get_logger

logger = get_logger(__name__)

class OptIn(object):

    url = "/v2/import"

    def __init__(self, mobile_number, first_name, surname, email, dob,
                 address="", town="", county=""):
        self.locals = locals()

    def submit_optin(self, http_client: HTTPClient, group):
        params = self.__validate_params()
        contents = {
            "mobilenumber": params['mobile_number'],
            "firstname": params['first_name'],
            "surname": params['surname'],
            "dateofbirth": params['dob'],
            "email": params['email']
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
        self.locals.__delitem__('self')
        new_dict = dict()
        for key in self.locals:
            if self.locals[key]:
                print(key + " : " + self.locals[key])
                new_dict[key] = validator[key](self.locals[key])
        return new_dict

