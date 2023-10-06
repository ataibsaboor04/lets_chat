import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:developer';

Future<void> sendPushNotifications(String title, String message) async {
  log('Pushing notification');
  final url = Uri.parse("https://fcm.googleapis.com/fcm/send");
  final body = {
    'notification': {
      'title': title,
      'body': message,
      "android_channel_id": 'let\'s_chat/chat',
    },
    'to': '/topics/chat',
  };

  try {
    var response = await http.post(
      url,
      headers: {
        HttpHeaders.authorizationHeader:
            'key=AAAAPoVdOVY:APA91bHbBgT8jxdl04fpeVCoNz-mdBiHa964RM_E7kPf45hV3wx-9GKkT2p6oEPKaDzWaLPSA0FSPPoNyWX_vaCW-pq0xINguSrSTYEGgt_Bk4kSvq2t4x2bRGS0hdZF-abv1rdAKoKT',
        HttpHeaders.contentTypeHeader: 'application/json',
      },
      body: jsonEncode(body),
    );
    log('Response status: ${response.statusCode}');
    log('Response body: ${response.body}');
  } catch (e) {
    log('Push Notification Error: $e');
  }
}

void main() {
  sendPushNotifications('Test', 'Received new messages.');
}
