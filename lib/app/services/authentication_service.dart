import 'package:encrypted_notes/app/repositories/user_repository.dart';
import 'package:encrypted_notes/app/libraries/encryption_library.dart';
import 'package:encrypted_notes/app/libraries/secure_storage_library.dart';

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

  saveKeyOfExistingUser(String username, String password, Map userData) async {
    var k1 = EncryptionLibrary().getEncryptKeyFromPassword(
      password,
      userData['salt'],
      userData['iv'],
      userData['k1'],
      userData['k3']
    );
    if (k1 == null) {
      return false;
    }

    await SecureStorageLibrary().setValue('k1', k1);
    return true;
  }

  createNewKeysForUser(String password) async {
    Map response = EncryptionLibrary().generateKeys(password);
    await SecureStorageLibrary().setValue('k1', response['k1']);
    response.remove('k1');
    return response;
  }

  saveNewUser(Map data) async {
    return await UserRepository().createNewUser(data);
  }
}