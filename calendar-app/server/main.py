from flask import Flask, request, jsonify
from google_auth_oauthlib.flow import InstalledAppFlow
from googleapiclient.discovery import build
import os
import google.generativeai as genai

app = Flask(__name__)

# Google Calendar API setup
SCOPES = ['https://www.googleapis.com/auth/calendar.readonly']
creds = None
if os.path.exists('token.json'):
    creds = Credentials.from_authorized_user_file('token.json', SCOPES)
if not creds or not creds.valid:
    if creds and creds.expired and creds.refresh_token:
        creds.refresh(Request())
    else:
        flow = InstalledAppFlow.from_client_secrets_file(
            'credentials.json', SCOPES)
        creds = flow.run_local_server(port=0)
    with open('token.json', 'w') as token:
        token.write(creds.to_json())

service = build('calendar', 'v3', credentials=creds)

# Gemini API setup
GEMINI_API_KEY = os.environ.get('GEMINI_API_KEY')
genai.configure(api_key=GEMINI_API_KEY)
model = genai.GenerativeModel('gemini-pro')

@app.route('/ask', methods=['POST'])
def ask():
    question = request.json.get('question')

    # Get calendar events
    now = datetime.datetime.utcnow().isoformat() + 'Z'  # 'Z' indicates UTC time
    events_result = service.events().list(calendarId='primary', timeMin=now,
                                        maxResults=10, singleEvents=True,
                                        orderBy='startTime').execute()
    events = events_result.get('items', [])

    # Create a prompt for the Gemini API
    prompt = f"""Here is my schedule for the next 10 events:
{events}

Question: {question}

Answer:"""

    # Call the Gemini API
    response = model.generate_content(prompt)

    return jsonify({'answer': response.text})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
