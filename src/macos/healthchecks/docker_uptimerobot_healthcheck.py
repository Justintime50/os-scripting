import os
import subprocess
import sys

import requests
from urllib3.util.retry import Retry

# Check if your Docker instance is reachable by checking the overall uptime of your apps via UptimeRobot
# Usage: UPTIME_ROBOT_API_KEY=123 python3 docker_uptimerobot_healthcheck.py


API_KEY = os.getenv('UPTIME_ROBOT_API_KEY')
MONITOR_DOWN_THRESHOLD = 0.3  # We expect 70% of the monitors to be up if Docker is reachable
REQUEST_TIMEOUT = 60


def main():
    response = get_uptimerobot_monitors()

    monitors = response["monitors"]
    num_of_monitors = len(monitors)
    up_monitor_status = 2  # per the UptimeRobot API docs, 2 is an "up" status and anything over it is "down"
    num_of_down_monitors = len([up_monitor for up_monitor in monitors if up_monitor["status"] > up_monitor_status])
    percentage_of_down_monitors = round(num_of_down_monitors / num_of_monitors, 2)

    if percentage_of_down_monitors > MONITOR_DOWN_THRESHOLD:
        restart_docker()
    else:
        print('UptimeRobot healthcheck passed.')


def get_uptimerobot_monitors():
    """Get the monitors from UptimeRobot.

    UptimeRobot is notoriously flakey (timing out or throwing 5xx errors), retry on failure before giving up.
    """
    retry_strategy = Retry(
        total=3,
        backoff_factor=1,
        status_forcelist=[
            429,
            500,
            502,
            503,
            504,
        ],
        allowed_methods=["POST"],
    )
    requests_session = requests.Session()
    requests_http_adapter = requests.adapters.HTTPAdapter(max_retries=retry_strategy)
    requests_session.mount(prefix="https://", adapter=requests_http_adapter)

    url = "https://api.uptimerobot.com/v2/getMonitors"
    payload = f"api_key={API_KEY}&format=json"
    headers = {
        "content-type": "application/x-www-form-urlencoded",
        "cache-control": "no-cache",
    }

    try:
        response = requests.request(
            "POST",
            url,
            data=payload,
            headers=headers,
            timeout=REQUEST_TIMEOUT,
        )
    except Exception as error:
        sys.exit(error)

    return response.json()


def restart_docker():
    try:
        subprocess.run(
            'killall Docker && killall "Docker Desktop" && killall com.docker.backend && sleep 10 && open /Applications/Docker.app',  # noqa
            stderr=subprocess.STDOUT,
            check=True,
            shell=True,
            text=True,
            timeout=30,
        )
        raise Exception('UptimeRobot healthcheck failed, restarting Docker...')
    except Exception:
        raise Exception('Failed to restart Docker!')


if __name__ == "__main__":
    main()
