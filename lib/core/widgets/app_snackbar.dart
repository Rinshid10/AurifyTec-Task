import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/theme.dart';

//  <--------- App Snack Bar --------->
//* TO give every screen one place for transient feedback so the style stays the same
class AppSnackBar {
  AppSnackBar._();

  //  <--------- Public Methods --------->
  //* TO replace any visible snackbar with the new message and optional action
  static void show(
    BuildContext context,
    String message, {
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 2),
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          duration: duration,
          //  <--------- Auto Dismiss --------->
          //* TO keep action snackbars timing out, since newer Flutter would otherwise pin them until dismissed
          persist: false,
          action: actionLabel == null
              ? null
              : SnackBarAction(
                  label: actionLabel,
                  onPressed: onAction ?? () {},
                ),
        ),
      );
  }

  //!  <--------- Connection --------->
  //* TO show a compact bar when the network drops or comes back
  static void connection({required bool online}) {
    final context = Get.overlayContext ?? Get.context;
    if (context == null) return;
    final colors = context.colors;
    final top = MediaQuery.paddingOf(context).top;
    final foreground = context.isDark ? AppColors.light.ink : colors.onButton;
    unawaited(
      _presentConnection(
        online: online,
        background: online ? colors.success : colors.danger,
        foreground: foreground,
        top: top,
      ),
    );
  }

  //* TO dismiss the current bar first so a newer connection message does not get closed with it
  static Future<void> _presentConnection({
    required bool online,
    required Color background,
    required Color foreground,
    required double top,
  }) async {
    if (Get.isSnackbarOpen) await Get.closeCurrentSnackbar();
    Get.rawSnackbar(
      messageText: Text(
        online ? 'Back online' : 'No internet connection',
        style: TextStyle(
          color: foreground,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
      icon: Icon(
        online ? Icons.wifi_rounded : Icons.wifi_off_rounded,
        color: foreground,
        size: 18,
      ),
      shouldIconPulse: false,
      backgroundColor: background,
      snackPosition: SnackPosition.TOP,
      snackStyle: SnackStyle.FLOATING,
      maxWidth: 260,
      margin: EdgeInsets.fromLTRB(16, top + 8, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      borderRadius: 20,
      duration: const Duration(seconds: 3),
      animationDuration: const Duration(milliseconds: 250),
      isDismissible: true,
    );
  }
}
