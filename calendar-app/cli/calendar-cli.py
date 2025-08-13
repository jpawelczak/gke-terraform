import requests
import sys

def main():
    if len(sys.argv) < 2:
        print('Usage: python calendar-cli.py <question>')
        return

    question = ' '.join(sys.argv[1:])

    response = requests.post('http://34.55.4.233/ask', json={'question': question})

    if response.status_code == 200:
        print(response.json()['answer'])
    else:
        print(f'Error: {response.text}')

if __name__ == '__main__':
    main()
