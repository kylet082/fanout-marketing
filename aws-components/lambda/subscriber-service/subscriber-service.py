import datetime

from sendmode_client.http.client import HTTPClient
from sendmode_client.dao.optin import OptIn
from mail_chimp.service.client import MailChimpClient
from mail_chimp.actions.audience import AudienceManager

from aws_utilities.aws_secret_manager import get_aws_secret

from c_logger.service import get_logger

logger = get_logger(__name__)


def lambda_handler(event, context):
    action = event.get('action')
    logger.info("Action: %s", action)

    if action == 'SENDMODE':
        result = sendmode_optin(event['aws_store'], event['group_id'], event['member_info'])
    elif action == 'MAILCHIMP':
        result = mailchimp_optin(event['aws_store'], event['audience_id'], event['member_info'])
    else:
        raise ValueError("Action argument not supported: `{}`".format(action))

    # Errors from either channel are raised by the client libraries, so reaching
    # here means the opt-in succeeded. Only a small summary goes back to the
    # step function, so no personal data ends up in its output.
    logger.info("%s opt-in succeeded", action)
    return result


def sendmode_optin(aws_store, group_id, member_info):
    config = get_aws_secret(aws_store)
    day, month = parse_birthday(member_info['birthday'])

    client = HTTPClient() \
        .auth(config['sendmode_key']) \
        .connect()

    new_member = OptIn(
        member_info['mobile_number'],
        member_info['first_name'],
        member_info['last_name'],
        member_info['email'],
        "{}/{}".format(day, month)  # dd/mm; we deliberately don't collect the birth year
    )
    response = new_member.submit_optin(client, group_id)
    return {'channel': 'SENDMODE', 'status': response.status}


def mailchimp_optin(aws_store, audience_id, member_info):
    config = get_aws_secret(aws_store)
    day, month = parse_birthday(member_info['birthday'])

    client = MailChimpClient(config['mailchimp_key'])
    am = AudienceManager(client, audience_id)

    response = am.add_to_audience(
        member_info['email'],
        member_info['first_name'],
        member_info['last_name'],
        "{}/{}".format(month, day),  # MailChimp birthday fields expect mm/dd
        member_info['mobile_number']
    )
    return {'channel': 'MAILCHIMP', 'status': response.get('status')}


def parse_birthday(value):
    """Parse a 'dd/mm' birthday into zero-padded (day, month) strings.

    Raises ValueError if the format or date is invalid. The message never
    includes the value itself, to keep personal data out of logs and errors.
    """
    parts = str(value).strip().split('/')
    if len(parts) != 2:
        raise ValueError("Birthday must be in dd/mm format")
    try:
        day, month = int(parts[0]), int(parts[1])
        datetime.date(2000, month, day)  # leap year, so 29/02 is accepted
    except ValueError:
        raise ValueError("Birthday is not a valid dd/mm date") from None
    return "{:02d}".format(day), "{:02d}".format(month)
