import 'dart:convert';

import 'package:http/http.dart' as http;

enum RequestAssistStatus {
  success,
  error,
  loading,
}

class RequestAssistent {
  static Future<Map<String, dynamic>> get(
      {required String url, Map<String, String>? headers}) async {
    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      return {
        "data": jsonDecode(response.body),
        "status": RequestAssistStatus.success
      };
    } else {
      return {"data": null, "status": RequestAssistStatus.error};
    }
  }
}
