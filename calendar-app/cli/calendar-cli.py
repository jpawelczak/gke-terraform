import requests
import argparse

def main():
    parser = argparse.ArgumentParser(description='Ask questions about your Google Calendar schedule.')
    parser.add_argument('question', type=str, help='The question to ask about your schedule.')
    args = parser.parse_args()

    response = requests.post('http://localhost:8080/ask', json={'question': args.question})

    if response.status_code == 200:
        print(response.json()['answer'])
    else:
        print(f'Error: {response.text}')

if __name__ == '__main__':
    main()
