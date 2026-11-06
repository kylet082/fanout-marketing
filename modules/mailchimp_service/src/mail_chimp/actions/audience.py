import json

from mailchimp_marketing.api_client import ApiClientError

from ..service.client import MailChimpClient
from ..common.errors import MailChimpError
from ..common.validation import validate

from c_logger.service import get_logger

logger = get_logger(__name__)


class AudienceManager(object):

    def __init__(self, mc: MailChimpClient, audience_id):
        self.mc = mc
        self.audience_id = audience_id

    def add_to_audience(self, email_address, first_name, surname, dob, mobile_number):
        params = validate({
            'email_address': email_address,
            'first_name': first_name,
            'surname': surname,
            'dob': dob,
            'mobile_number': mobile_number,
        })

        member_info = {
            "email_address": params['email_address'],
            "phone_number": params['mobile_number'],
            "status": "subscribed",
            "merge_fields": {
                "FNAME": params['first_name'],
                "LNAME": params['surname'],
                "PHONE": params['mobile_number'],
                "BIRTHDAY": params['dob']
            },
            "tags": ['birthday'],
        }

        logger.debug("Adding member to audience %s: %s", self.audience_id, member_info)
        try:
            response = self.mc.client().lists.add_list_member(self.audience_id, member_info)
        except ApiClientError as error:
            title = _error_title(error)
            # The error body can include the email address, so only log it at DEBUG.
            logger.error("MailChimp add_list_member failed (audience=%s, status=%s, title=%s)",
                         self.audience_id, error.status_code, title)
            logger.debug("MailChimp error body: %s", error.text)
            raise MailChimpError(
                "MailChimp rejected the request: {} ({})".format(title, error.status_code),
                status=error.status_code,
                title=title,
            ) from error

        logger.info("Added member to audience %s (status=%s)",
                    self.audience_id, response.get('status'))
        return response


def _error_title(error):
    try:
        return json.loads(error.text).get('title', 'Unknown error')
    except (TypeError, ValueError, AttributeError):
        return 'Unknown error'
