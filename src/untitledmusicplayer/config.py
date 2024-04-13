import json
import logging
import os
import pathlib

from platformdirs import user_data_dir, user_cache_dir

base_path = os.path.abspath(os.path.dirname(__file__))
data_path = user_data_dir('untitledmusicapp', 'melissaautumn')
cache_path = user_cache_dir('untitledmusicapp', 'melissaautumn')

creds_path = pathlib.Path(f'{data_path}/creds/server_creds.json')

def save_server_creds(host, port, username, access_token):
    # HIGHLY SECURE!
    # Ensure the path is created
    logging.info(f"Saving credentials to {creds_path}")
    creds_path.parent.mkdir(parents=True, exist_ok=True)

    with open(creds_path, 'w') as fh:
        fh.write(json.dumps({
            'host': host,
            'port': port,
            'username': username,
            'access_token': access_token
        }))

    return True


def load_server_creds():
    data = {}
    try:
        with open(creds_path) as fh:
            data = json.loads(fh.read())
    except FileNotFoundError:
        return None

    return data