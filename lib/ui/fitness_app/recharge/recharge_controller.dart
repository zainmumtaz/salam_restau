import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:salam_restau/models/payment_method_model.dart';

import '../../../utilities/constants.dart';
import '../../../utilities/routes.dart';
import '../../../utilities/shared_preferences.dart';
import '../../../utilities/snack_alerts.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RechargeController extends GetxController {
  var dropdownItems = <Map<String, String>>[].obs;
  var selectedValue = RxnString();

  TextEditingController amountController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  var amountError = false.obs;
  var isLoading = false.obs;
  var amount;

  bool get isFormValid {
    final amountText = amountController.text.trim();
     amount = int.tryParse(amountText) ?? 0;
    return selectedValue.value != null && amount > 0;
  }

  @override
  void onInit() {
    super.onInit();
    loadDropdownFromPrefs();
  }

  Future<void> loadDropdownFromPrefs() async {
    List<PaymentMethodModel> methods = await SharedPref.get_pay_method();
    if (methods.isNotEmpty) {
      dropdownItems.value = methods
          .map((method) => {
        'label': method.title,
        'value': method.id.toString(),
      })
          .toList();
    } else {
      dropdownItems.clear();
    }
  }


  void onAmountChanged(String value) {
  amount = int.tryParse(value) ?? 0;
    amountError.value = amount <= 0;
  }

  Future<void> rechargeNow(BuildContext context) async {
    if (!isFormValid || isLoading.value) return;

    isLoading.value = true;

    try {
      // API call simulation

      await recharge(context);

    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> recharge(BuildContext context) async {

    final authtoken = await SharedPref.getAuthToken();
    if (authtoken == null) {
      SnackbarUtils.showError("Authentication token missing");
      isLoading.value = false;
      return;
    }

    final body = {
      'amount': amount,
      'restrict_payer_mobile': phoneController.text.trim(),
      'wave_id': selectedValue.value,
    };

    try {

      final response = await http.post(
        Uri.parse('$BaseUrl/wave/checkout/sessions'),
        headers: {
          'Authorization': 'Bearer $authtoken',
          'Content-Type': 'application/json',
        },
        body: json.encode(body),
      );

      final jsonBody = json.decode(response.body);

      if (response.statusCode == 201 && jsonBody['success'] == true) {
        SnackbarUtils.showSuccess(jsonBody['message']);
        phoneController.clear();
        amountController.clear();
        //Navigator.pop(context);
        String value=jsonBody["data"]["wave_launch_url"].toString();
        print("values=$value");
        Get.offNamed(AppRoutes.browser, arguments: value);
      } else {
        SnackbarUtils.showError(jsonBody['message'] ?? "Transfer failed");
      }

    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}

