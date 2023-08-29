import json
import os
import shutil

import requests
from requests.packages.urllib3.exceptions import InsecureRequestWarning

UNIFI_IP = os.getenv('UNIFI_IP', '192.168.1.1')
UNIFI_SITE = os.getenv('UNIFI_SITE', 'default')
UNIFI_USERNAME = os.getenv('UNIFI_USERNAME')
UNIFI_PASSWORD = os.getenv('UNIFI_PASSWORD')
UNIFI_BACKUP_LOCATION = os.getenv('UNIFI_PASSWORD_LOCATION')
TIMEOUT = 10

# API Docs: https://ubntwiki.com/products/software/unifi-controller/api

# Usage: UNIFI_USERNAME=admin UNIFI_PASSWORD=123 UNIFI_BACKUP_LOCATION=my/backups python3 get_last_console_backup.py


def main():
    requests.packages.urllib3.disable_warnings(InsecureRequestWarning)
    session = requests.Session()
    headers = {
        "Accept": "application/json",
        "Content-Type": "application/json",
    }

    # Must login first
    login_response = session.post(
        f'https://{UNIFI_IP}/api/auth/login',
        headers=headers,
        json={
            'username': UNIFI_USERNAME,
            'password': UNIFI_PASSWORD,
        },
        verify=False,
        timeout=TIMEOUT,
    )
    csrf_token = login_response.headers.get('X-CSRF-Token')
    headers['X-CSRF-Token'] = csrf_token

    # Most deployments will only have a single session titled `default`, if not, you can get them with this
    # sites = session.get(
    #     f'https://{UNIFI_IP}/proxy/network/api/self/sites',
    #     headers=headers,
    #     verify=False,
    #     timeout=TIMEOUT,
    # )
    # print(sites.text)

    # TODO: This isn't creating backups, for now, setup automatic backups in the Unifi Console
    # created_backup = session.post(
    #     f'https://{UNIFI_IP}/proxy/network/api/s/{UNIFI_SITE}/cmd/backup',
    #     headers=headers,
    #     json={'cmd': 'backup'},
    #     verify=False,
    #     timeout=TIMEOUT,
    # )
    # print(created_backup.text)

    backups = session.post(
        f'https://{UNIFI_IP}/proxy/network/api/s/{UNIFI_SITE}/cmd/backup',
        headers=headers,
        json={'cmd': 'list-backups'},
        verify=False,
        timeout=TIMEOUT,
    )
    # print(backups.text)

    backups_json = json.loads(backups.text)
    if backups_json.get('data'):
        most_recent_backup_filename = backups_json['data'][-1].get('filename')

    backup_content = session.get(
        f'https://{UNIFI_IP}/proxy/network/dl/autobackup/{most_recent_backup_filename}',
        headers=headers,
        verify=False,
        timeout=TIMEOUT,
        stream=True,
    )

    with open(os.path.join(UNIFI_BACKUP_LOCATION, most_recent_backup_filename), 'wb') as out:
        shutil.copyfileobj(backup_content.raw, out)


if __name__ == '__main__':
    main()
