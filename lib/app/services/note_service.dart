import 'package:encrypted_notes/app/repositories/user_repository.dart';

class NoteService {
  Future<Map> getUserNotes(int userNo) async {
    Map response = await UserRepository().getUserNotes(userNo);
    if (response.containsKey('error')) {
      return {
        'success': false
      };
    }
    return {
      'success': true,
      'data': response['notes']
    };
  }
}