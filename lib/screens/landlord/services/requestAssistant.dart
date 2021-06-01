import 'dart:convert';

import 'package:http/http.dart' as http;

class RequestAssistant {
  static Future<dynamic> getRequest(String link) async {
    Uri url = Uri.parse(link);
    http.Response response = await http.get(url);

    try {
      if (response.statusCode == 200) {
        String jsonData = response.body;
        var decodedData = jsonDecode(jsonData);
        return decodedData;
      } else {
        return 'failed';
      }
    } catch (e) {
      return 'failed';
    }
  }
}
