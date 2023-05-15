import 'dart:convert';

import 'package:http/http.dart';

Future<String> sendNotifcation(
    {required String title,
    required String message,
    required String token,
    var doctorId = '',
    var doctorName = ''}) async {
  Map<String, dynamic> body = {
    "to": token,
    "notification": {"body": message, "title": title},
    "data": {"doctorID": doctorId, "doctorName": doctorName, "From": "Doctor"},
  };
  final msg = jsonEncode(body);
  Map<String, String> headers = {
    "Content-Type": "application/json",
    "Authorization":
        "key=AAAANLrY2CU:APA91bEdhKkzCHU7IdUSwusI8vc-6kdgaInhCNIqXzGplbBGeEexiIiz1RAV6iCB-vWxDqV0NMHCkcmDt_F9Jz3Ipi65WU5z0za5HFqpoLv2gC48VJErD8_6PZBMaO0xlAhCKm-eJbfN"
  };
  Response response = await post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: headers,
      body: msg);
  print(response.body.toString());
  return response.body;
}
