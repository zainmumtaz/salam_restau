import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:salam_restau/models/payment_method_model.dart';
import 'package:salam_restau/models/response_transaction_model.dart';
import 'package:salam_restau/models/transaction_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/room_info_model.dart';
import '../models/user_model.dart';

class SharedPref {
  // Save Auth Token
  static Future<void> saveAuthToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('auth_token', token);
  }

  // Save User Data
  static Future<void> saveUserData(Map<String, dynamic> userData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user_data', json.encode(userData)); // Convert the user data map to JSON string
  }



  // Get Auth Token
  static Future<String?> getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  static Future<void> save_comp_transaction(Map<String, dynamic> trans_model) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('comp_tran_data', json.encode(trans_model));
    //print("check transc model");
    print(prefs.getString('comp_tran_data'));
    String formattedDateTime = DateFormat('yyyy-MM-dd hh:mm:ss').format(DateTime.now());
    await prefs.setString('sync_date_time', formattedDateTime);// Convert the user data map to JSON string
  }

  static Future<void> saveRoomsDetails(RoomInfoModel model) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('rooms_data', json.encode(model.toJson()));
  }

  static Future<RoomInfoModel?> getRoomsDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString('rooms_data');
    if (data != null) {
      return RoomInfoModel.fromJson(json.decode(data));
    }
    return null;
  }


  // static Future<void> save_pay_methods(List<dynamic> payMethods) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //
  //   // List ko JSON string me convert karke save karo
  //   await prefs.setString('pay_method_data', json.encode(payMethods));
  //
  //   print("✅ Pay methods saved in SharedPref");
  //   print(prefs.getString('pay_method_data')); // Debugging
  // }
  //
  // static Future<void> save_pay_method(Map<String, dynamic> json) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final method = PaymentMethodModel.fromJson(json);
  //   prefs.setString('pay_method_data', jsonEncode(method.toJson()));
  //   print(prefs.getString('pay_method_data'));
  // }


  // Save list of payment methods
  static Future<void> save_pay_method(String dataJson) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('pay_method_data', dataJson);
  }

// Get list of payment methods
  static Future<List<PaymentMethodModel>> get_pay_method() async {
    final prefs = await SharedPreferences.getInstance();
    final dataString = prefs.getString('pay_method_data');
    if (dataString != null) {
      List<dynamic> list = jsonDecode(dataString);
      return list.map((e) => PaymentMethodModel.fromJson(e)).toList();
    }
    return [];
  }


  // Save list of payment methods
  static Future<void> save_pay_out_method(String dataJson) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('pay_out_method_data', dataJson);
  }

// Get list of payment methods
  static Future<List<PaymentMethodModel>> get_pay_out_method() async {
    final prefs = await SharedPreferences.getInstance();
    final dataString = prefs.getString('pay_out_method_data');
    if (dataString != null) {
      List<dynamic> list = jsonDecode(dataString);
      return list.map((e) => PaymentMethodModel.fromJson(e)).toList();
    }
    return [];
  }


  // Get User Data
  static Future<UserModel?> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userDataString = prefs.getString('user_data');
    if (userDataString != null) {
      return UserModel.fromJson(json.decode(userDataString));
    }
    return null;
  }

  static Future<ResponseTransactionModel?> get_comp_trans_Data() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userDataString = prefs.getString('comp_tran_data');
    if (userDataString != null) {
      return ResponseTransactionModel.fromJson(json.decode(userDataString));
    }
    return null;
  }

  // static Future<PaymentMethodModel?> get_pay_method() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final dataString = prefs.getString('pay_method_data');
  //   if (dataString != null) {
  //     return PaymentMethodModel.fromJson(jsonDecode(dataString));
  //   }
  //   return null;
  // }

  // Update Solde in User Data
  static Future<void> updateSolde(double solde) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userDataString = prefs.getString('user_data');

    if (userDataString != null) {
      // Decode existing user data
      Map<String, dynamic> userDataMap = json.decode(userDataString);

      // Check if 'info' exists and update 'solde'
      if (userDataMap['info'] != null) {
        userDataMap['info']['solde'] = solde;

        // Save updated user data back to SharedPreferences
        prefs.setString('user_data', json.encode(userDataMap));
      }
    }
  }


  // Clear all saved data (if needed)
  static Future<void> clear() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('auth_token');
    prefs.remove('user_data');
    prefs.remove('code_image_path');
    prefs.remove('profile_image_path');
    prefs.remove('comp_tran_data');
    prefs.remove('sync_date_time');
    prefs.remove('pay_method_data');
    prefs.remove('rooms_data');
  }

  static Future<void> clearhistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('comp_tran_data');

  }

  static Future<void> saveProfileImagePath(String path) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_image_path', path);
  }

  static Future<String?> getProfileImagePath() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('profile_image_path');
  }

  static Future<void> saveCodeImagePath(String path) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('code_image_path', path);
  }

  static Future<String?> getCodeImagePath() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('code_image_path');
  }

  static Future<String?> getsynctime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('sync_date_time');
  }


}