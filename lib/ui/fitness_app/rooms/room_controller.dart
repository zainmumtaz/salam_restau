import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:salam_restau/models/payment_method_model.dart';

import '../../../models/room_info_model.dart';
import '../../../utilities/alerts.dart';
import '../../../utilities/constants.dart';
import '../../../utilities/routes.dart';
import '../../../utilities/shared_preferences.dart';
import '../../../utilities/snack_alerts.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
   print(savedRoom.value!.buildingName);
  }

  // void payNow(int id, int roid) {
  //   // Yahan aap apna API call ya payment ka logic likh sakte ho
  //   print("Pay Now pressed for ID: $id");
  // }

  Future<void> payNow(BuildContext context,int id, int roid) async {
    bool? confirm = await AlertHelper.showConfirmation(
      title: "Confirm",
      text: "Are your Sure You Want To Pay?",
    );

    if (confirm == true) {
      final authtoken = await SharedPref.getAuthToken();
      if (authtoken == null) {
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
        print("URL=$BaseUrl/student-pay-monthly=== token=$authtoken=====id=$id");

        final jsonBody = json.decode(response.body);

        if (response.statusCode == 200 && jsonBody['success'] == true) {
          SnackbarUtils.showSuccess(jsonBody['message']);
          Navigator.pop(context);
        } else {
          SnackbarUtils.showError(jsonBody['message'] ?? "Payment failed");
        }
      } catch (e) {
        print ("Error:$e");
        SnackbarUtils.showError("Error: $e");
      } finally {

      }
    }
  }




}


