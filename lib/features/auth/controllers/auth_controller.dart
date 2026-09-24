import 'dart:async';

import 'package:get/get.dart';

import '../../../app/routes.dart';
import '../data/auth_models.dart';
import '../data/auth_repository.dart';

//  <--------- Auth Controller --------->
//* TO hold the signed-in user and move between the auth screens and the main shell
class AuthController extends GetxController {
  AuthController(this._repository);

  //  <--------- Fields --------->
  final AuthRepository _repository;

  late final Rxn<AuthUser> user = Rxn<AuthUser>(_repository.currentUser);
  StreamSubscription<AuthUser?>? _sessionSub;

  //  <--------- Getters --------->
  bool get isSignedIn => user.value != null;

  //* TO show a name in headers, falling back to Guest if a screen is reached while signed out
  String get displayName => user.value?.name ?? 'Guest';

  String get firstName => user.value?.firstName ?? 'Guest';

  String get email => user.value?.email ?? '';

  //  <--------- Lifecycle --------->
  //* TO follow session changes made outside the app, like a revoked Firebase session
  @override
  void onInit() {
    super.onInit();
    _sessionSub = _repository.authStateChanges.listen((next) {
      user.value = next;
      if (next == null && Get.currentRoute != AppRoutes.login) {
        Get.offAllNamed(AppRoutes.login);
      }
    });
  }

  @override
  void onClose() {
    _sessionSub?.cancel();
    super.onClose();
  }

  //  <--------- Sign In --------->
  //* TO sign in through Firebase and replace the stack with the shell
  Future<void> signIn({required String email, required String password}) async {
    user.value = await _repository.signIn(email: email, password: password);
    Get.offAllNamed(AppRoutes.shell);
  }

  //  <--------- Sign Up --------->
  //* TO create the account through Firebase and replace the stack with the shell
  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    user.value = await _repository.signUp(
      name: name,
      email: email,
      password: password,
    );
    Get.offAllNamed(AppRoutes.shell);
  }

  //  <--------- Password Reset --------->
  Future<void> sendPasswordReset(String email) =>
      _repository.sendPasswordReset(email);

  //!  <--------- Sign Out --------->
  //* TO clear the session; the auth-state listener above is the single place that navigates to login
  Future<void> signOut() => _repository.signOut();
}
