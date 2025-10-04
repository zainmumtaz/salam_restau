import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;


import '../../../models/room_info_model.dart';
import '../../../utilities/alerts.dart';
import '../../../utilities/constants.dart';

import '../../../utilities/shared_preferences.dart';
import '../../../utilities/snack_alerts.dart';


class RoomController extends GetxController {
  var savedRoom = Rxn<RoomInfoModel>();
  var isVisible = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    // Thoda delay de kar animation trigger karenge
    Future.delayed(const Duration(milliseconds: 300), () {
      isVisible.value = true;
    });
    await loadrooms();
  }

  Future<void> loadrooms() async {
    savedRoom.value = await SharedPref.getRoomsDetails();

  }

  // void payNow(int id, int roid) {
  //   // Yahan aap apna API call ya payment ka logic likh sakte ho
  //   print("Pay Now pressed for ID: $id");
  // }

  Future<void> payNow(BuildContext context, int id, int roid) async {
    bool? confirm = await AlertHelper.showConfirmation(
      title: "Confirm",
      text: "Are you sure you want to pay?",
    );

    if (confirm != true) return;

    // Show QuickAlert loading
    // QuickAlert.show(
    //   context: context,
    //   type: QuickAlertType.loading,
    //   title: 'Processing',
    //   text: 'Please wait...',
    //   barrierDismissible: false, // cannot cancel
    // );
     AlertHelper.showLoading(title: "Please Wait", text: "Request is Being Process");

    final authtoken = await SharedPref.getAuthToken();
    if (authtoken == null) {
      Navigator.pop(context); // Close loader
      SnackbarUtils.showError("Authentication token missing");
      return;
    }

    final body = {
      'room_order_detail_id': id,
      'id': id,
    };

    try {
      final response = await http.post(
        Uri.parse('$BaseUrl/student-pay-monthly'),
        headers: {
          'Authorization': 'Bearer $authtoken',
          'Content-Type': 'application/json',
        },
        body: json.encode(body),
      );

      final jsonBody = json.decode(response.body);

      Navigator.pop(context); // Close loader

      if (response.statusCode == 200 && jsonBody['success'] == true) {
      AlertHelper.showSuccess(title: "Transaction Successful", text: jsonBody['message']);
        //Navigator.pop(context); // Close previous screen if needed
      } else {
        AlertHelper.showError(title: "Transaction Failed", text: jsonBody['message']);
      }
    } catch (e) {
      Navigator.pop(context); // Close loader
      AlertHelper.showError(title: "Transaction Failed", text: e.toString());
    }
  }






}


