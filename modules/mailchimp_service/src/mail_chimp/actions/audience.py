from ..service.client import MailChimpClient
from mailchimp_marketing.api_client import ApiClientError
from ..common.validation import validator

from c_logger.service import get_logger

logger = get_logger(__name__)

class AudienceManager(object):

    optin_status_yes = {'status': 'subscribed'}

    def __init__(self, mc: MailChimpClient, audience_id):
        self.mc = mc
        self.audience_id = audience_id

    def add_to_audience(self, email_address, first_name, surname, dob, mobile_number):
        params = self.__validate_param(locals())

        member_info = {
            "email_address": params['email_address'],
            "phone_number" : params['mobile_number'],
            "status": "subscribed",
            "merge_fields": {
                "FNAME": params['first_name'],
                "LNAME": params['surname'],
                "PHONE": params['mobile_number'],
                "BIRTHDAY": params['dob']
            },
            "tags": ['birthday'],
        }

        logger.info("Memeber : " + str(member_info))
        try:
            response = self.mc.client().lists.add_list_member(self.audience_id, member_info)
            response = "t"
            logger.info('Response : ' + str(response))
        except ApiClientError as error:
            logger.error("Error: {}".format(error.text))

        return response

    def __validate_param(self, params):
        params.__delitem__('self')
        new_dict = dict()
        for key in params:
            if params[key]:
                print(key + " : " + params[key])
                new_dict[key] = validator[key](params[key])
        return new_dict
