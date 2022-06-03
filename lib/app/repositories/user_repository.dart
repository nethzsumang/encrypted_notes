import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class UserRepository {
  Future<Map> getUserByUsername(String username) async {
    var apiUrl = dotenv.get('API_URL', fallback: 'http://localhost');
    var url = Uri.parse('$apiUrl/api/users?username=$username');
    var response = await http.get(url);
    return jsonDecode(response.body);
  }

  Future<Map> createNewUser(Map data) async {
    var apiUrl = dotenv.get('API_URL', fallback: 'http://localhost');
    var url = Uri.parse('$apiUrl/api/users');
    var response = await http.post(
      url,
      body: jsonEncode(data),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      }
    );
    return jsonDecode(response.body);
  }
}