import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:google_map_i/authentication/authentication_manager.dart';
import 'package:google_map_i/models/user.dart';
import 'package:google_map_i/operation/operation_screen.dart';

class LoginViewModel extends GetxController {
  Future<bool?> loginUser(String username, String password) async {
    var _authManager = AuthManager();

    var result =
        await _authManager.loginUser(User(name: username, password: password));

    if (result) {
      Get.off(OperationScreen());
    }

    return result;
  }
}
