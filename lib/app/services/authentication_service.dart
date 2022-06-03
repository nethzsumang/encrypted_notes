import 'package:encrypted_notes/app/repositories/user_repository.dart';

class AuthenticationService {
  Future<Map> checkIfUserExists(String username) async {
    Map response = await (UserRepository()).getUserByUsername(username);
    if (response.containsKey('error') == true) {
      return {
        'success': false
      };
    }

    return {
      'success': true,
      'data': response['user']
    };
  }
}