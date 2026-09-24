import 'package:flutter_test/flutter_test.dart';
import 'package:product_explorer/features/auth/data/auth_models.dart';
import 'package:product_explorer/features/auth/data/firebase_auth_repository.dart';

void main() {
  group('FirebaseAuthRepository.mapCode', () {
    test('maps credential failures to invalidCredentials', () {
      for (final code in [
        'user-not-found',
        'wrong-password',
        'invalid-credential',
        'INVALID_LOGIN_CREDENTIALS',
        'user-disabled',
      ]) {
        expect(
          FirebaseAuthRepository.mapCode(code),
          AuthErrorCode.invalidCredentials,
          reason: code,
        );
      }
    });

    test('maps the remaining known codes', () {
      expect(
        FirebaseAuthRepository.mapCode('invalid-email'),
        AuthErrorCode.invalidEmail,
      );
      expect(
        FirebaseAuthRepository.mapCode('email-already-in-use'),
        AuthErrorCode.emailAlreadyInUse,
      );
      expect(
        FirebaseAuthRepository.mapCode('weak-password'),
        AuthErrorCode.weakPassword,
      );
      expect(
        FirebaseAuthRepository.mapCode('network-request-failed'),
        AuthErrorCode.network,
      );
    });

    test('unknown codes fall back to unknown', () {
      expect(
        FirebaseAuthRepository.mapCode('something-new'),
        AuthErrorCode.unknown,
      );
    });
  });
}
