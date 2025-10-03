import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../../models/student_model.dart';
import '../../../utilities/constants.dart';
import '../../../utilities/shared_preferences.dart';
import '../../../utilities/snack_alerts.dart';



class TransferController extends GetxController {
  final TextEditingController textController = TextEditingController();

  var isLoading = false.obs;
  var isSubmitting = false.obs;
  var errorText = RxnString();
  var sm = Rxn<StudentModel>();
  var isQRCodeValidated = false.obs;

  late final String qrdata;

  @override
  void onInit() {
    super.onInit();
    //qrdata = "\$2y\$10\$BMjUs0zhi4MilwaLhCrwre8HRO5BGMH2ExrNqKh5rQtseX7V3wud2";
    qrdata = Get.arguments?['qrdata'] ?? '';
  }

  Future<void> validateQRCode() async {
    if (isQRCodeValidated.value || qrdata.isEmpty || !qrdata.startsWith("\$2y\$10")) {
      SnackbarUtils.showError("QR Code invalid or already validated.");
      return;
    }

    isLoading.value = true;
    final authtoken = await SharedPref.getAuthToken();
    if (authtoken == null) {
      SnackbarUtils.showError("Authentication token is missing.");
      isLoading.value = false;
      return;
    }

    final Uri uri = Uri.parse('$BaseUrl/etudiant?identifiant=$qrdata');
    final headers = {'Authorization': 'Bearer $authtoken'};

    try {
      final response = await http.get(uri, headers: headers);
      final jsonBody = json.decode(response.body);

      if (response.statusCode == 200 && jsonBody['success'] == true) {
        sm.value = StudentModel.fromJson(jsonBody["data"]);
        SnackbarUtils.showSuccess(jsonBody['message'] ?? "Api Done");
      } else {
        sm.value = null;
        SnackbarUtils.showError(jsonBody['message'] ?? "Student not found.");
      }
    } catch (e) {
      SnackbarUtils.showError("Error: $e");
    } finally {
      isLoading.value = false;
      isQRCodeValidated.value = true;
    }
  }

  void validateInput(String value) {
    if (value.isEmpty) {
      errorText.value = "Field cannot be empty";
    } else if (!isNumeric(value)) {
      errorText.value = "Only numeric values allowed";
    } else if (double.tryParse(value)! <= 0) {
      errorText.value = "Value must be greater than zero";
    } else {
      errorText.value = null;
    }
  }

  bool isNumeric(String value) => double.tryParse(value) != null;

  bool isValidInput() {
    final value = textController.text.trim();
    validateInput(value);
    return errorText.value == null;
  }

  String getTodayDate() {
    return DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  Future<void> confirmTransfer(BuildContext context) async {
    if (isSubmitting.value) return;

    if (!isValidInput()) return;

    isSubmitting.value = true;

    final authtoken = await SharedPref.getAuthToken();
    if (authtoken == null) {
      SnackbarUtils.showError("Authentication token missing");
      isSubmitting.value = false;
      return;
    }

    final body = {
      'receiver_id': sm.value?.id,
      'montant': textController.text.trim(),
      'date': getTodayDate(),
    };

    try {
      final response = await http.post(
        Uri.parse('$BaseUrl/transfert'),
        headers: {
          'Authorization': 'Bearer $authtoken',
          'Content-Type': 'application/json',
        },
        body: json.encode(body),
      );

      final jsonBody = json.decode(response.body);

      if (response.statusCode == 200 && jsonBody['success'] == true) {
        SnackbarUtils.showSuccess("Transfer Successfully");
        textController.clear();
        Navigator.pop(context);
      } else {
        SnackbarUtils.showError(jsonBody['message'] ?? "Transfer failed");
      }
    } catch (e) {
      SnackbarUtils.showError("Error: $e");
    } finally {
      isSubmitting.value = false;
    }
  }
}
