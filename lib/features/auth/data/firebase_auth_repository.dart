import 'package:firebase_auth/firebase_auth.dart' as fb;

import 'auth_models.dart';
import 'auth_repository.dart';
import 'auth_validators.dart';

//  <--------- Firebase Auth Repository --------->
//* TO back the auth contract with Firebase email and password accounts
class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository(this._auth);

  //  <--------- Fields --------->
  final fb.FirebaseAuth _auth;

  //  <--------- Current User --------->
  //* TO expose the session Firebase restored on this device, mapped to the app model
  @override
  AuthUser? get currentUser => _toAuthUser(_auth.currentUser);

  //  <--------- Auth State Stream --------->
  @override
  Stream<AuthUser?> get authStateChanges =>
      _auth.authStateChanges().map(_toAuthUser);

  //!  <--------- Sign In --------->
  @override
  Future<AuthUser> signIn({
    required String email,
    required String password,
  }) async {
    if (!AuthValidators.isValidEmail(email)) {
      throw const AuthException(AuthErrorCode.invalidEmail);
    }
    final credential = await _guard(
      () => _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      ),
    );
    return _require(credential.user);
  }

  //  <--------- Sign Up --------->
  //* TO create the account, store the display name and return the signed-in user
  @override
  Future<AuthUser> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    if (!AuthValidators.isValidEmail(email)) {
      throw const AuthException(AuthErrorCode.invalidEmail);
    }
    if (!AuthValidators.isStrongPassword(password)) {
      throw const AuthException(AuthErrorCode.weakPassword);
    }
    final credential = await _guard(
      () => _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      ),
    );
    final user = _require(credential.user);
    //  <--------- Display Name --------->
    //* TO store the name as best effort; the account already exists and is signed in, so a failure here must not strand the user on the register screen
    try {
      await credential.user!.updateDisplayName(name.trim());
      await credential.user!.reload();
    } catch (_) {}
    return AuthUser(uid: user.uid, name: name.trim(), email: user.email);
  }

  //  <--------- Password Reset --------->
  @override
  Future<void> sendPasswordReset(String email) {
    if (!AuthValidators.isValidEmail(email)) {
      throw const AuthException(AuthErrorCode.invalidEmail);
    }
    return _guard(() => _auth.sendPasswordResetEmail(email: email.trim()));
  }

  //!  <--------- Sign Out --------->
  @override
  Future<void> signOut() => _auth.signOut();

  //  <--------- Helpers --------->
  //* TO turn a Firebase user into the app model, falling back to the email prefix as a name
  static AuthUser? _toAuthUser(fb.User? user) {
    if (user == null) return null;
    final email = user.email ?? '';
    final name = user.displayName?.trim();
    return AuthUser(
      uid: user.uid,
      name: name == null || name.isEmpty ? email.split('@').first : name,
      email: email,
    );
  }

  static AuthUser _require(fb.User? user) {
    final mapped = _toAuthUser(user);
    if (mapped == null) throw const AuthException(AuthErrorCode.unknown);
    return mapped;
  }

  //!  <--------- Error Mapping --------->
  //* TO convert Firebase failures into the app error codes the screens already handle
  static Future<T> _guard<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on fb.FirebaseAuthException catch (e) {
      throw AuthException(mapCode(e.code), _friendlyMessage(e));
    }
  }

  static AuthErrorCode mapCode(String code) => switch (code) {
    'invalid-email' => AuthErrorCode.invalidEmail,
    'user-not-found' ||
    'wrong-password' ||
    'invalid-credential' ||
    'INVALID_LOGIN_CREDENTIALS' ||
    'user-disabled' => AuthErrorCode.invalidCredentials,
    'email-already-in-use' => AuthErrorCode.emailAlreadyInUse,
    'weak-password' => AuthErrorCode.weakPassword,
    'network-request-failed' => AuthErrorCode.network,
    _ => AuthErrorCode.unknown,
  };

  static String? _friendlyMessage(fb.FirebaseAuthException e) =>
      switch (e.code) {
        'too-many-requests' =>
          'Too many attempts. Please wait a moment and try again.',
        'operation-not-allowed' =>
          'Email sign-in is not enabled for this Firebase project.',
        'user-disabled' => 'This account has been disabled.',
        _ => null,
      };
}
