import os
import subprocess
import sys

import requests

# Check if your Docker instance is reachable by checking the overall uptime of your apps via UptimeRobot
# Usage: UPTIME_ROBOT_API_KEY=123 venv/bin/python docker_uptimerobot_healthcheck.py


API_KEY = os.getenv('UPTIME_ROBOT_API_KEY')
MONITOR_DOWN_THRESHOLD = 0.3  # We expect 70% of the monitors to be up if Docker is reachable
REQUEST_TIMEOUT = 60


def main():
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
        ).json()
    except Exception as error:
        sys.exit(error)

    monitors = response["monitors"]
    num_of_monitors = len(monitors)
    up_monitor_status = 2  # per the UptimeRobot API docs, 2 is an "up" status and anything over it is "down"
    num_of_down_monitors = len([up_monitor for up_monitor in monitors if up_monitor["status"] > up_monitor_status])
    percentage_of_down_monitors = round(num_of_down_monitors / num_of_monitors, 2)

    if percentage_of_down_monitors > MONITOR_DOWN_THRESHOLD:
        restart_docker()
    else:
        print('UptimeRobot healthcheck passed.')


def restart_docker():
    try:
        subprocess.run(
            'killall Docker && killall "Docker Desktop" && killall com.docker.backend && sleep 10 && open'
            ' /Applications/Docker.app',  # noqa
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
