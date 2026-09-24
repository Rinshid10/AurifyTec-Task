//  <--------- Auth User Model --------->
//* TO expose the signed-in user to the rest of the app
class AuthUser {
  const AuthUser({required this.uid, required this.name, required this.email});

  //  <--------- Fields --------->
  final String uid;
  final String name;
  final String email;

  //  <--------- First Name --------->
  String get firstName => name.trim().split(RegExp(r'\s+')).first;

  //  <--------- Serialization --------->
  Map<String, dynamic> toJson() => {'uid': uid, 'name': name, 'email': email};

  factory AuthUser.fromJson(Map<String, dynamic> json) => AuthUser(
    uid: json['uid'] as String? ?? '',
    name: json['name'] as String? ?? '',
    email: json['email'] as String? ?? '',
  );
}

//  <--------- Auth Error Code Enum --------->
//* TO name why an auth call failed, mirroring the Firebase Auth error codes so screens can map them to copy in one place
enum AuthErrorCode {
  invalidEmail,
  invalidCredentials,
  emailAlreadyInUse,
  weakPassword,
  network,
  unknown,
}

//!  <--------- Auth Exception --------->
//* TO carry the failure code thrown by AuthRepository calls with a message ready to show to the user
class AuthException implements Exception {
  const AuthException(this.code, [this._message]);

  //  <--------- Fields --------->
  final AuthErrorCode code;
  final String? _message;

  //  <--------- Message --------->
  String get message => _message ?? _defaultMessage(code);

  //  <--------- Default Messages --------->
  //* TO map each error code to user-facing copy
  static String _defaultMessage(AuthErrorCode code) => switch (code) {
    AuthErrorCode.invalidEmail => 'That email address doesn\'t look right.',
    AuthErrorCode.invalidCredentials =>
      'Incorrect email or password. Please try again.',
    AuthErrorCode.emailAlreadyInUse =>
      'An account with this email already exists. Try signing in instead.',
    AuthErrorCode.weakPassword => 'Passwords need at least 8 characters.',
    AuthErrorCode.network => 'No connection. Check your network and try again.',
    AuthErrorCode.unknown => 'Something went wrong. Please try again.',
  };

  //  <--------- Debug String --------->
  @override
  String toString() => 'AuthException(${code.name}): $message';
}
