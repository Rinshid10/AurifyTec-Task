import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../data/auth_validators.dart';
import 'auth_form_controller.dart';

//  <--------- Register Form Controller --------->
//* TO hold the Create Account form state on top of the shared auth form plumbing
class RegisterFormController extends AuthFormController {
  RegisterFormController(super.auth);

  //  <--------- Fields --------->
  final name = TextEditingController();
  final confirmPassword = TextEditingController();
  final nameError = RxnString();
  final confirmPasswordError = RxnString();

  //  <--------- Validation --------->
  //* TO check every field and keep the messages so the view can show them
  @override
  bool validate() {
    nameError.value = AuthValidators.nameError(name.text);
    emailError.value = AuthValidators.emailError(email.text);
    passwordError.value = AuthValidators.passwordError(password.text);
    confirmPasswordError.value = AuthValidators.confirmPasswordError(
      password.text,
      confirmPassword.text,
    );
    return nameError.value == null &&
        emailError.value == null &&
        passwordError.value == null &&
        confirmPasswordError.value == null;
  }

  //  <--------- Perform --------->
  @override
  Future<void> perform() =>
      auth.signUp(name: name.text, email: email.text, password: password.text);

  //  <--------- Dispose --------->
  @override
  void onClose() {
    name.dispose();
    confirmPassword.dispose();
    super.onClose();
  }
}
