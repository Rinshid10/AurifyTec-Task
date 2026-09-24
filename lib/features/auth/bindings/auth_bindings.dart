import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../controllers/login_form_controller.dart';
import '../controllers/register_form_controller.dart';

//  <--------- Login Binding --------->
//* TO keep the Sign In form state alive only while the screen is
class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginFormController(Get.find<AuthController>()));
  }
}

//  <--------- Register Binding --------->
//* TO keep the Create Account form state alive only while the screen is
class RegisterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RegisterFormController(Get.find<AuthController>()));
  }
}
