import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../features/auth/controllers/auth_controller.dart';
import '../routes.dart';

//!  <--------- Auth Guard --------->
//* TO redirect signed-out users to the login screen
class AuthGuard extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final signedIn = Get.find<AuthController>().isSignedIn;
    return signedIn ? null : const RouteSettings(name: AppRoutes.login);
  }
}

//!  <--------- Guest Guard --------->
//* TO keep signed-in users away from the auth screens
class GuestGuard extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final signedIn = Get.find<AuthController>().isSignedIn;
    return signedIn ? const RouteSettings(name: AppRoutes.shell) : null;
  }
}
