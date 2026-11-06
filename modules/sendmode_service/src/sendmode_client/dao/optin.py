import json

from ..http.client import HTTPClient, Response
from ..errors import SendmodeError
from ..utils.validation import validate

from c_logger.service import get_logger

logger = get_logger(__name__)


class OptIn(object):

    url = "/v2/import"

    def __init__(self, mobile_number, first_name, surname, email, dob,
                 address="", town="", county=""):
        self.params = validate({
            'mobile_number': mobile_number,
            'first_name': first_name,
            'surname': surname,
            'email': email,
            'dob': dob,
            'address': address,
            'town': town,
            'county': county,
        })

    def submit_optin(self, http_client: HTTPClient, group) -> Response:
        contents = {
            "mobilenumber": self.params['mobile_number'],
            "firstname": self.params['first_name'],
            "surname": self.params['surname'],
            "dateofbirth": self.params['dob'],
            "email": self.params['email']
        }
        body = {
            "group": group,
            "importdata": json.dumps(contents)
        }
        header = {"Content-Type": "application/x-www-form-urlencoded; charset=UTF-8"}

        logger.debug("Submitting Sendmode opt-in to group %s: %s", group, contents)
        response = http_client.post_method(self.url, header, body)
        logger.debug("Sendmode response body: %s", response.body)

        if not 200 <= response.status < 300:
            logger.error("Sendmode opt-in failed (group=%s, status=%s %s)",
                         group, response.status, response.reason)
            raise SendmodeError(
                "Sendmode rejected the request: {} {}".format(response.status, response.reason),
                status=response.status,
            )

        logger.info("Sendmode opt-in succeeded (group=%s, status=%s)", group, response.status)
        return response
