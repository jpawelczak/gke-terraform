import requests
import sys
import subprocess

def main():
    if len(sys.argv) < 2:
        print('Usage: python calendar-cli.py <question>')
        return

    question = ' '.join(sys.argv[1:])

    try:
        ip_address = subprocess.check_output([
            'kubectl', 'get', 'service', 'calendar-app', '-o', 'jsonpath={.status.loadBalancer.ingress[0].ip}'
        ]).decode('utf-8').strip()

        url = f'http://{ip_address}/ask'

        response = requests.post(url, json={'question': question})

        if response.status_code == 200:
            print(response.json()['answer'].encode('utf-8'))
        else:
            print(f'Error: {response.text}')
    except (subprocess.CalledProcessError, FileNotFoundError):
        print('Error: Failed to get the IP address of the calendar-app service.')
        print('Please make sure that kubectl is installed and configured correctly.')

if __name__ == '__main__':
    main()