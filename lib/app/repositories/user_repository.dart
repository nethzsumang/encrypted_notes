import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class UserRepository {
  Future<Map> getUserByUsername(String username) async {
    var apiUrl = dotenv.get('API_URL', fallback: 'http://localhost');
    var url = Uri.parse('$apiUrl/api/users?username=$username'); print('$apiUrl/users?username=$username');
    var response = await http.get(url);
    return jsonDecode(response.body);
  }
}