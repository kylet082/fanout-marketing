from sendmode_client.http.client import HTTPClient
from sendmode_client.dao.optin import OptIn
from mail_chimp.service.client import MailChimpClient
from mail_chimp.actions.audience import AudienceManager

from aws_utilities.aws_secret_manager import get_aws_secret

from c_logger.service import get_logger

logger = get_logger(__name__)


def lambda_handler(event, context):
    action = event['action']
    logger.info("Action : " + action)

    if action == 'SENDMODE':
        response = sendmode_optin(event['aws_store'],
                                  event['group_id'], event['member_info'])
    elif action == 'MAILCHIMP':
        response = mailchimp_optin(event['aws_store'],
                                   event['audience_id'], event['member_info'])
    else:
        raise ValueError("Action argument not supported : `{}`".format(action))

    # vaildate response here
    logger.info(response)


def sendmode_optin(aws_store, group_id, member_info):
    config = get_aws_secret(aws_store)

    client = HTTPClient() \
        .auth(config['sendmode_key'])\
        .connect()

    new_memeber = OptIn(
        member_info['mobile_number'],
        member_info['first_name'],
        member_info['last_name'],
        member_info['email'],
        member_info['birthday']
    )
    res = new_memeber.submit_optin(client, group_id)
    return res


def mailchimp_optin(aws_store, audience_id, member_info):
    config = get_aws_secret(aws_store)

    client = MailChimpClient(config['mailchimp_key'])
    am = AudienceManager(client, audience_id)

    res = am.add_to_audience(
        member_info['email'],
        member_info['first_name'],
        member_info['last_name'],
        member_info['birthday'],
        member_info['mobile_number']
    )

    return res