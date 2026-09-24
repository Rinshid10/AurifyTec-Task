import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:product_explorer/app/theme.dart';
import 'package:product_explorer/features/auth/controllers/auth_controller.dart';
import 'package:product_explorer/features/auth/controllers/login_form_controller.dart';
import 'package:product_explorer/features/auth/data/auth_models.dart';
import 'package:product_explorer/features/auth/data/auth_repository.dart';
import 'package:product_explorer/features/auth/views/login_view.dart';

void main() {
  tearDown(Get.reset);

  testWidgets('login screen shows the sign-in form', (tester) async {
    final auth = AuthController(_QuietAuth());
    Get.put(auth);
    Get.put(LoginFormController(auth));

    await tester.pumpWidget(
      GetMaterialApp(theme: AppTheme.light(), home: const LoginView()),
    );

    expect(find.text('Login here'), findsOneWidget);
    expect(find.text('Sign in'), findsOneWidget);
    expect(find.text('Create new account'), findsOneWidget);
  });
}

class _QuietAuth extends AuthRepository {
  @override
  AuthUser? get currentUser => null;

  @override
  Stream<AuthUser?> get authStateChanges => const Stream.empty();

  @override
  Future<AuthUser> signIn({
    required String email,
    required String password,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<AuthUser> signUp({
    required String name,
    required String email,
    required String password,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<void> sendPasswordReset(String email) async {}

  @override
  Future<void> signOut() async {}
}
