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
        return api_key.split('-')[1]
