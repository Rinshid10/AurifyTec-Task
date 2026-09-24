//  <--------- Auth Validators --------->
//* TO share validation rules so screens and repositories agree
class AuthValidators {
  AuthValidators._();

  //  <--------- Rules --------->
  static final _email = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]{2,}$');

  static const minPasswordLength = 8;

  //  <--------- Checks --------->
  static bool isValidEmail(String value) => _email.hasMatch(value.trim());

  static bool isStrongPassword(String value) =>
      value.length >= minPasswordLength;

  //  <--------- Error Messages --------->
  //* TO return the message to show under a field, or null when the value is fine
  static String? emailError(String value) {
    if (value.trim().isEmpty) return 'Enter your email address.';
    if (!isValidEmail(value)) return 'Enter a valid email address.';
    return null;
  }

  static String? passwordError(String value) {
    if (value.isEmpty) return 'Enter your password.';
    if (!isStrongPassword(value)) {
      return 'Use at least $minPasswordLength characters.';
    }
    return null;
  }

  static String? nameError(String value) {
    if (value.trim().length < 2) return 'Enter your full name.';
    return null;
  }

  static String? confirmPasswordError(String password, String confirm) {
    if (confirm.isEmpty) return 'Confirm your password.';
    if (confirm != password) return 'Passwords do not match.';
    return null;
  }
}
