import 'package:flutter/material.dart';
import 'package:get/get.dart';

//!  <--------- Confirm Dialog --------->
//* TO ask a yes or no question and resolve to true only when confirmed
Future<bool> confirmDialog({
  required String title,
  required String message,
  String confirmLabel = 'Confirm',
  String cancelLabel = 'Cancel',
}) async {
  final result = await Get.dialog<bool>(
    AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Get.back(result: false),
          child: Text(cancelLabel),
        ),
        FilledButton(
          onPressed: () => Get.back(result: true),
          child: Text(confirmLabel),
        ),
      ],
    ),
  );
  return result ?? false;
}

//  <--------- Info Dialog --------->
//* TO show a single-button information message
Future<void> infoDialog({
  required String title,
  required String message,
  String buttonLabel = 'Got it',
}) {
  return Get.dialog<void>(
    AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [FilledButton(onPressed: Get.back, child: Text(buttonLabel))],
    ),
  );
}
