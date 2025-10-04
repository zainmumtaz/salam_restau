import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:salam_restau/models/room_info_model.dart';
import 'package:salam_restau/utilities/alerts.dart';

import '../../../utilities/constants.dart';
import '../../../utilities/file_utils.dart';
import '../../../utilities/shared_preferences.dart';
import '../../../utilities/snack_alerts.dart';
import '../../utilities/routes.dart';

class LoginController extends GetxController {
  // Controllers for form fields
  final matriculeController = TextEditingController();
  final passwordController = TextEditingController();

  final idcontroller = TextEditingController();
  final lncontroller = TextEditingController();

  final otpcontroller = TextEditingController();
  final newpasscontroller = TextEditingController();
  final conpasscontroller = TextEditingController();
  // Reactive variables for UI binding (only for loading, error, etc.)
  var isLoading = false.obs;
  var matriculeError = ''.obs;  // For Matricule specific error
  var passwordError = ''.obs;
  var sid_error = ''.obs;  // For Matricule specific error
  var ln_error = ''.obs;

  var otp_error = ''.obs;
  var newpass_error = ''.obs;
  var conpass_error = ''.obs;


  var authToken = ''.obs;
  var isPasswordVisible = false.obs;


  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  // Function to validate matricule (username)
  String? validateMatricule(String matricule) {
    if (matricule.isEmpty) {
      return "This cannot be empty";
    }
    return null; // No error
  }

  // Function to validate password
  String? validatePassword(String password) {
    if (password.isEmpty) {
      return "Password cannot be empty";
    } else if (password.length < 5) {
      return "Password must be at least 5 characters long";
    }
    return null; // No error
  }

  // Function to handle login
  Future<void> login() async {
    String matricule = matriculeController.text.trim();
    String password = passwordController.text.trim();

    // Validate matricule and password before proceeding
    matriculeError.value = validateMatricule(matricule) ?? '';
    passwordError.value = validatePassword(password) ?? '';

    // If there are any validation errors, do not proceed
    if (matriculeError.isNotEmpty || passwordError.isNotEmpty) {
      return;
    }

    isLoading.value = true;

    final String apiUrl = '$BaseUrl/login';  // Replace with your API URL
    final Map<String, String> data = {
      'matricule': matricule,
      'password': password,
    };

    try {
      final response = await http.post(Uri.parse(apiUrl), body: data);

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        if (responseData['success']) {

          // You can store user info in shared preferences here
          await SharedPref.saveAuthToken(responseData['data']['token']);
          await SharedPref.saveUserData(responseData['data']['user']);
          await SharedPref.save_pay_method(jsonEncode(responseData['data']['recharge']));
          //  print(responseData['data']['user']);
         // print("Transactions=${responseData['data']['transactions']}");
         await SharedPref.save_comp_transaction(responseData['data']['transactions']);

          await SharedPref.save_pay_out_method(jsonEncode(responseData['data']['payout']));


         //await loadhistory();
          await loadrooms();
         // await loadpaymenmethods();
        //  await loadpayoutmenmethods();

          // After user data is saved
          if (responseData['data']['user']['info'] != null) {
            String imageUrl = responseData['data']['user']['info']['photo'];
            String codeUrl = responseData['data']['user']['info']['code'];

            String? usavedPath = await FileUtils.downloadAndSaveImage(imageUrl, 'user_img.jpg');

            String? csavedPath = await FileUtils.downloadAndSaveImage(codeUrl, 'user_code.svg');


            if (csavedPath != null) {

              await SharedPref.saveCodeImagePath(csavedPath);
            } else {

            }

            if (usavedPath != null) {

              await SharedPref.saveProfileImagePath(usavedPath);
            } else {

            }
          }

          Get.offAllNamed('/home');
          print("I am here at 94");
        } else {

          //SnackbarUtils.showError(login_failed);
          AlertHelper.showError(title: "Error", text: login_failed);
        }
      } else {

        SnackbarUtils.showError("Error: ${response.statusCode}");
      }
    } catch (e) {
      print(e);

      SnackbarUtils.showError(something_went_wrong);
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> loadhistory({String? optionalParam}) async {
    var authtoken = await SharedPref.getAuthToken(); // Récupérer le token
    if (authtoken == null) {
      SnackbarUtils.showError(auth_token_missing); // Erreur snackbar si le token est nul
      return;
    }

   // final String apiUrl = BaseUrl + '/transaction';
    final String apiUrl = '$BaseUrl/student-transaction-histories'; // Point de terminaison API
    final Map<String, String> headers = {
      'Authorization': 'Bearer $authtoken', // Passer le token dans l'en-tête
    };

    // Ajouter des paramètres de requête si un paramètre optionnel est présent


    final Uri uri = Uri.parse(apiUrl);

    try {
      // Requête GET avec en-têtes
      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        // Gérer la réponse
        final responseData = jsonDecode(response.body);
        await SharedPref.save_comp_transaction(responseData['data']);
        //res.value = ResponseTransactionModel.fromJson(responseData["data"]);
        //AllTransactions = res.value!.transactions;
        // filteredTransactions = res.value!.transactions;

      } else {
        // Gérer la réponse en cas d'erreur
        SnackbarUtils.showError("Échec de la récupération des données");
      }
    } catch (e) {
      // Gérer l'exception

      SnackbarUtils.showError("$e");
    }
  }

  Future<void> loadrooms({String? optionalParam}) async {
    var authtoken = await SharedPref.getAuthToken(); // Récupérer le token
    if (authtoken == null) {
      SnackbarUtils.showError(auth_token_missing); // Erreur snackbar si le token est nul
      return;
    }

    // final String apiUrl = BaseUrl + '/transaction';
    final String apiUrl = '$BaseUrl/student-room-details'; // Point de terminaison API
    final Map<String, String> headers = {
      'Authorization': 'Bearer $authtoken', // Passer le token dans l'en-tête
    };

    // Ajouter des paramètres de requête si un paramètre optionnel est présent


    final Uri uri = Uri.parse(apiUrl);

    try {
      // Requête GET avec en-têtes
      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        // Gérer la réponse
        final responseData = jsonDecode(response.body);
       final roomInfo= RoomInfoModel.fromApi(responseData);

        await SharedPref.saveRoomsDetails(roomInfo);
      } else {
        // Gérer la réponse en cas d'erreur
        SnackbarUtils.showError("Échec de la récupération des données");
      }
    } catch (e) {
      // Gérer l'exception

      SnackbarUtils.showError("$e");
    }
  }

  Future<void> loadpaymenmethod() async {
    var authtoken = await SharedPref.getAuthToken(); // Récupérer le token
    if (authtoken == null) {
      SnackbarUtils.showError(auth_token_missing); // Erreur snackbar si le token est nul
      return;
    }

    final String apiUrl = BaseUrl + '/wave/account'; // Point de terminaison API
    final Map<String, String> headers = {
      'Authorization': 'Bearer $authtoken', // Passer le token dans l'en-tête
    };



    final Uri uri = Uri.parse(apiUrl);

    try {
      // Requête GET avec en-têtes
      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        // Gérer la réponse
        final responseData = jsonDecode(response.body);
        await SharedPref.save_pay_method(responseData['data']);

        //res.value = ResponseTransactionModel.fromJson(responseData["data"]);
        //AllTransactions = res.value!.transactions;
        // filteredTransactions = res.value!.transactions;

      } else {
        // Gérer la réponse en cas d'erreur
        SnackbarUtils.showError("Échec de la récupération des données");
      }
    } catch (e) {
      // Gérer l'exception

      SnackbarUtils.showError("$e");
    }
  }

  Future<void> loadpaymenmethods() async {
    var authtoken = await SharedPref.getAuthToken();
    if (authtoken == null) {
      SnackbarUtils.showError(auth_token_missing);
      return;
    }

    final String apiUrl = BaseUrl + '/wave/account';
    final Map<String, String> headers = {
      'Authorization': 'Bearer $authtoken',
    };

    try {
      final Uri uri = Uri.parse(apiUrl);
      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData['success'] == true && responseData['data'] is List) {
          // Store the list as JSON string
          await SharedPref.save_pay_method(jsonEncode(responseData['data']));

        } else {
          SnackbarUtils.showError("Invalid data format received");
        }
      } else {
        SnackbarUtils.showError("Échec de la récupération des données");
      }
    } catch (e) {

      SnackbarUtils.showError("$e");
    }
  }

  Future<void> loadpayoutmenmethods() async {
    var authtoken = await SharedPref.getAuthToken();
    if (authtoken == null) {
      SnackbarUtils.showError(auth_token_missing);
      return;
    }

    final String apiUrl = BaseUrl + '/wave-payout-account';
    final Map<String, String> headers = {
      'Authorization': 'Bearer $authtoken',
    };

    try {
      final Uri uri = Uri.parse(apiUrl);
      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData['success'] == true && responseData['data'] is List) {
          // Store the list as JSON string
          await SharedPref.save_pay_out_method(jsonEncode(responseData['data']));

        } else {
          SnackbarUtils.showError("Invalid data format received");
        }
      } else {
        SnackbarUtils.showError("Échec de la récupération des données");
      }
    } catch (e) {

      SnackbarUtils.showError("$e");
    }
  }



  void fpstepone(){

    Get.toNamed(AppRoutes.fpso);
  }

  void backtologin(){

    Get.offAllNamed(AppRoutes.login);
  }


  Future<void> otprequest() async {
    String student_id = idcontroller.text.trim();
    String last_name = lncontroller.text.trim();

    // Validate student ID and last name before proceeding
    sid_error.value = validateMatricule(student_id) ?? '';
    ln_error.value = validateMatricule(last_name) ?? '';

    // Stop execution if there are validation errors
    if (sid_error.isNotEmpty || ln_error.isNotEmpty) {
      return;
    }

    isLoading.value = true;

    final String apiUrl = '$BaseUrl/otp-forgot-password';  // Complete API endpoint
    final Map<String, String> data = {
      'student_id': student_id,
      'last_name': last_name,
    };

    try {
      final response = await http.post(Uri.parse(apiUrl), body: data);

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        if (responseData['success']==true) {
          SnackbarUtils.showSuccess(responseData['message']);
          Get.offNamed(AppRoutes.fpst);  // Navigate to OTP screen
        } else {
          SnackbarUtils.showError(responseData['message'] ?? 'Login failed.');
        }
      } else {
        SnackbarUtils.showError("Error: ${response.statusCode}");
      }
    } catch (e) {
      print('Error: $e');
      SnackbarUtils.showError('Something went wrong. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }
  //
  Future<void> resetpaswordbackup() async {
    String otp = otpcontroller.text.trim();
    String newpassword = newpasscontroller.text.trim();
    String password_confirmation = conpasscontroller.text.trim();

    // Validate student ID and last name before proceeding
    otp_error.value = validateMatricule(otp) ?? '';
    newpass_error.value = validatePassword(newpassword) ?? '';
    conpass_error.value=validatePassword(password_confirmation) ?? '';

    // Stop execution if there are validation errors
    if (otp_error.isNotEmpty || otp_error.isNotEmpty) {
      return;
    }



    isLoading.value = true;

    final String apiUrl = '$BaseUrl/update-reset-password';  // Complete API endpoint
    final Map<String, String> data = {
      'otp': otp,
      'password': newpassword,
      'password_confirmation': password_confirmation,
    };

    try {
      final response = await http.post(Uri.parse(apiUrl), body: data);

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);

        if (responseData['success']==true) {
          SnackbarUtils.showSuccess(responseData['message']);
          Get.back();  // Navigate to OTP screen
        } else {
          SnackbarUtils.showError(responseData['message'] ?? 'password reset failed.');
        }
      } else {
        SnackbarUtils.showError("Error: ${response.statusCode}");
      }
    } catch (e) {

      SnackbarUtils.showError('Something went wrong. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resetpasword() async {

    String otp = otpcontroller.text.trim();
    String newpassword = newpasscontroller.text.trim();
    String password_confirmation = conpasscontroller.text.trim();

    // 🔹 Field validations
    otp_error.value = validateMatricule(otp) ?? '';
    newpass_error.value = validatePassword(newpassword) ?? '';
    conpass_error.value = validatePassword(password_confirmation) ?? '';

    // 🔹 Check if passwords match
    if (newpassword != password_confirmation) {
      conpass_error.value = 'Passwords do not match';
    }

    // 🔹 Stop execution if any validation error exists
    if (otp_error.isNotEmpty ||
        newpass_error.isNotEmpty ||
        conpass_error.isNotEmpty) {
      return;
    }

    isLoading.value = true;

    final String apiUrl = '$BaseUrl/update-reset-password';
    final Map<String, String> data = {
      'otp': otp,
      'password': newpassword,
      'password_confirmation': password_confirmation,
    };

    try {
      final response = await http.post(Uri.parse(apiUrl), body: data);

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);

        if (responseData['success'] == true) {
          SnackbarUtils.showSuccess(responseData['message']);
          Get.back(); // Navigate back to login
        } else {
          SnackbarUtils.showError(responseData['message'] ?? 'Password reset failed.');
        }
      } else {
        SnackbarUtils.showError("Error: ${response.statusCode}");
      }
    } catch (e) {
      SnackbarUtils.showError('Something went wrong. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }






}