import '../data/auth_validators.dart';
import 'auth_form_controller.dart';

//  <--------- Login Form Controller --------->
//* TO hold the Sign In form state on top of the shared auth form plumbing
class LoginFormController extends AuthFormController {
  LoginFormController(super.auth);

  //  <--------- Validation --------->
  @override
  bool validate() {
    emailError.value = AuthValidators.emailError(email.text);
    passwordError.value = password.text.isEmpty ? 'Enter your password.' : null;
    return emailError.value == null && passwordError.value == null;
  }

  //  <--------- Perform --------->
  @override
  Future<void> perform() =>
      auth.signIn(email: email.text, password: password.text);
}
