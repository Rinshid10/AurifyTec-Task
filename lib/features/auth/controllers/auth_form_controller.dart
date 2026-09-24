import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../data/auth_models.dart';
import 'auth_controller.dart';

//  <--------- Auth Form Controller --------->
//* TO share text controllers, field errors, password visibility and the submit flow between the sign-in and create-account forms
abstract class AuthFormController extends GetxController {
  AuthFormController(this.auth);

  //  <--------- Fields --------->
  final AuthController auth;

  final email = TextEditingController();
  final password = TextEditingController();

  //  <--------- State --------->
  final obscurePassword = true.obs;
  final loading = false.obs;
  final emailError = RxnString();
  final passwordError = RxnString();

  //!  <--------- Form Error --------->
  //* TO hold the message returned by the repository like wrong password or email in use
  final formError = RxnString();

  //  <--------- Password Visibility --------->
  void togglePasswordVisibility() => obscurePassword.toggle();

  //  <--------- Validation --------->
  //* TO run field validation, store the messages and return true when the form can be submitted
  @protected
  bool validate();

  //  <--------- Perform --------->
  //* TO make the auth call once validation passes
  @protected
  Future<void> perform();

  //  <--------- Submit --------->
  //* TO validate, show loading, run the auth call and surface any error
  Future<void> submit() async {
    formError.value = null;
    if (!validate()) return;

    FocusManager.instance.primaryFocus?.unfocus();
    loading.value = true;
    try {
      await perform();
    } on AuthException catch (e) {
      formError.value = e.message;
    } catch (_) {
      formError.value = const AuthException(AuthErrorCode.unknown).message;
    } finally {
      loading.value = false;
    }
  }

  //  <--------- Dispose --------->
  @override
  void onClose() {
    email.dispose();
    password.dispose();
    super.onClose();
  }
}
