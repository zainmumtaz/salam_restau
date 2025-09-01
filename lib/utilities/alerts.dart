import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:get/get.dart';

class AlertHelper {
  // Error Alert
  static void showError({required String title, required String text}) {
    QuickAlert.show(
      context: Get.context!,
      type: QuickAlertType.error,
      title: title,
      text: text,
      confirmBtnText: 'OK',
      confirmBtnColor: Colors.red,
      backgroundColor: Colors.white,
      titleColor: Colors.red,
      textColor: Colors.red,
    );
  }

  // Warning Alert
  static void showWarning({required String title, required String text}) {
    QuickAlert.show(
      context: Get.context!,
      type: QuickAlertType.warning,
      title: title,
      text: text,
      confirmBtnText: 'OK',
      confirmBtnColor: Colors.yellow[700]!,
      backgroundColor: Colors.black,
      titleColor: Colors.yellow,
      textColor: Colors.white,
    );
  }

  // Loading Alert - will remain until dismissed manually
  static void showLoading({required String title, required String text}) {
    QuickAlert.show(
      context: Get.context!,
      type: QuickAlertType.loading,
      title: title,
      text: text,
      barrierDismissible: false,
      backgroundColor: Colors.black,
      titleColor: Colors.white,
      textColor: Colors.white,
    );
  }

  // Success Alert
  static void showSuccess({required String title, required String text}) {
    QuickAlert.show(
      context: Get.context!,
      type: QuickAlertType.success,
      title: title,
      text: text,
      confirmBtnText: 'OK',
      confirmBtnColor: Colors.green,
      backgroundColor: Colors.white,
      titleColor: Colors.green,
      textColor: Colors.green,
    );
  }

  // Confirmation Alert - OK for forward, Cancel for back
  static Future<bool?> showConfirmation({
    required String title,
    required String text,
  }) async {
    bool? result = await QuickAlert.show(
      context: Get.context!,
      type: QuickAlertType.confirm,
      title: title,
      text: text,
      confirmBtnText: 'Se déconnecter',
      cancelBtnText: 'Annuler',
      confirmBtnColor: Colors.red,
      onConfirmBtnTap: () {
        Get.back(result: true); // user confirmed
      },
      onCancelBtnTap: () {
        Get.back(result: false); // user cancelled
      },
    );
    return result;
  }


  // Dismiss loading manually
  static void dismiss() {
    if (Get.isDialogOpen!) {
      Get.back();
    }
  }
}
