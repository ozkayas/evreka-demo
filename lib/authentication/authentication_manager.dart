import 'package:google_map_i/models/user.dart';

class AuthManager {
  /// Fake method returns true if username is 'evreka'
  Future<bool> loginUser(User user) async {
    bool result = false;

    await Future.delayed(Duration(seconds: 2), () {
      if (user.name.toLowerCase() == 'evreka' && user.password == '123456') {
        result = true;
      } else {
        result = false;
      }
    });

    return result;
  }
}
