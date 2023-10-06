import requests

# Replace 'YOUR_SERVER_KEY' with your Firebase project's Server Key
server_key = 'AAAAPoVdOVY:APA91bHbBgT8jxdl04fpeVCoNz-mdBiHa964RM_E7kPf45hV3wx-9GKkT2p6oEPKaDzWaLPSA0FSPPoNyWX_vaCW-pq0xINguSrSTYEGgt_Bk4kSvq2t4x2bRGS0hdZF-abv1rdAKoKT'

# FCM endpoint for sending messages to a topic
url = 'https://fcm.googleapis.com/fcm/send'

# Headers with authorization key
headers = {
    'Authorization': 'key=' + server_key,
    'Content-Type': 'application/json',
}

# Payload for the notification with a topic
payload = {
    'notification': {
        'title': '3 New Messages',
        'body': 'Tap to read.',
    },
    'to': '/topics/chat',  # Replace with the name of your topic
}

# Send the POST request to FCM
response = requests.post(url, headers=headers, json=payload)

# Check the response
if response.status_code == 200:
    print('Notification sent to topic successfully')
else:
    print('Failed to send notification to topic:',
          response.status_code, response.text)
