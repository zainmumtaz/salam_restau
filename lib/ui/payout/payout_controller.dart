import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;



import '../../../utilities/constants.dart';
import '../../../utilities/shared_preferences.dart';
import '../../../utilities/snack_alerts.dart';



import '../../models/payment_method_model.dart';
import '../../utilities/alerts.dart';
import '../history/historycontroller.dart';
import '../home/homecontroller.dart';

class PayoutController extends GetxController {
  final HomeController hc = Get.find<HomeController>();
  final HistoryController hsc = Get.find<HistoryController>();
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
    hc.user.value!.info!.numero.toString();
    loadDropdownFromPrefs();
  }

  Future<void> loadDropdownFromPrefs() async {
    List<PaymentMethodModel> methods = await SharedPref.get_pay_out_method();
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

      await payout(context);

    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> payout(BuildContext context) async {

    final authtoken = await SharedPref.getAuthToken();
    if (authtoken == null) {
      SnackbarUtils.showError("Authentication token missing");
      isLoading.value = false;
      return;
    }

    final body = {
      'amount': amount,
      'mobile': phoneController.text.trim(),
      'wave_id': selectedValue.value,
    };


    try {

      final response = await http.post(
        Uri.parse('$BaseUrl/wave-payout-request'),
        headers: {
          'Authorization': 'Bearer $authtoken',
          'Content-Type': 'application/json',
        },
        body: json.encode(body),
      );

      final jsonBody = json.decode(response.body);

      if (response.statusCode == 200 && jsonBody['success'] == true) {
        //SnackbarUtils.showSuccess(jsonBody['message']);
        phoneController.clear();
        amountController.clear();
        selectedValue.value = null;

        var textmsg =
            "Transaction: ${jsonBody['data']['payout_id']}\n"
            "Montant: ${jsonBody['data']['net_amount']}\n"
            "Frais : ${jsonBody['data']['fee_charged']}\n"
            "Total : ${jsonBody['data']['total'] }\n";



        AlertHelper.showSuccess(title: jsonBody['message'], text: textmsg);
        await hc.silentrefreshData();
        hsc.showFilteredList.value=false;

        await hsc.loadHistory();
        hsc.filterTransactions();
        Navigator.of(context).pop();
      } else {
       // print(jsonBody['message']);
        AlertHelper.showError(title: 'Transcation Failed', text:jsonBody['message'].toString());
       // SnackbarUtils.showError(jsonBody['message'] ?? "Transfer failed");
      }

    } catch (e) {
      print(e.toString());
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}

