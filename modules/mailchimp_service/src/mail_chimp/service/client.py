import mailchimp_marketing as MailchimpMarketing
from mailchimp_marketing import Client


class MailChimpClient(object):

    def __init__(self, api_key):
        self.api_key = api_key

    def client(self) -> Client:
        mailchimp = MailchimpMarketing.Client()
        mailchimp.set_config({
            'api_key': self.api_key,
            'server': self.__get_server(self.api_key),
        })
        return mailchimp

    def __get_server(self, api_key):
        # MailChimp keys end with the data centre, e.g. "abc123-us6"
        parts = api_key.rsplit('-', 1)
        if len(parts) != 2 or not parts[1]:
            raise ValueError("MailChimp API key has no data centre suffix (expected '<key>-<dc>')")
        return parts[1]
