import 'auth_models.dart';

//  <--------- Auth Repository --------->
//* TO define the contract the auth controller depends on, implemented by Firebase Authentication
abstract class AuthRepository {
  //  <--------- Current User --------->
  //* TO return the restored session, if any, synchronously at startup
  AuthUser? get currentUser;

  //  <--------- Auth State Stream --------->
  //* TO emit the user whenever the session changes, including sign-outs made outside the app
  Stream<AuthUser?> get authStateChanges;

  //  <--------- Sign In --------->
  Future<AuthUser> signIn({required String email, required String password});

  //  <--------- Sign Up --------->
  Future<AuthUser> signUp({
    required String name,
    required String email,
    required String password,
  });

  //  <--------- Password Reset --------->
  //* TO email a reset link to an existing account
  Future<void> sendPasswordReset(String email);

  //!  <--------- Sign Out --------->
  Future<void> signOut();
}
