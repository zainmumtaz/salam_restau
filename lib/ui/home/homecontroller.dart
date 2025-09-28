import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/quickalert.dart';

import '../../../models/response_transaction_model.dart';
import '../../../models/room_info_model.dart';
import '../../../models/transaction_model.dart';
import '../../../models/user_model.dart';
import '../../../utilities/alerts.dart';
import '../../../utilities/constants.dart';
import '../../../utilities/routes.dart';
import '../../../utilities/shared_preferences.dart';
import '../../../utilities/snack_alerts.dart';
import '../../utilities/file_utils.dart';

class HomeController extends GetxController {
  var user = Rxn<UserModel>();
  var selectedDate = Rxn<DateTime>();
  var filteredTransactions = <TransactionModel>[].obs;
  var AllTransactions = <TransactionModel>[].obs;
  var res = Rxn<ResponseTransactionModel>();// Objet UserModel réactif
  var qrcode=''.obs;
  var img=''.obs;
  var synctime=''.obs;
  var selectedFilterId = Rxn<int>();
// Add a reactive variable to track the selected filter index
  RxInt selectedFilterIndex = 0.obs;

  @override
  Future<void> onInit() async {
    super.onInit();

    user.value = await SharedPref.getUserData();
    await loadimages();
    //await loadUserData();
    await loadhistory();


  }

  // Method to set the selected date






// Helper function to compare only the date part (ignoring the time)
  bool _isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }






  // Charger les données de l'utilisateur à partir des préférences partagées
  Future<void> loadUserData() async {
    user.value = await SharedPref.getUserData();
    if (user.value == null) {
      // Gérer le cas où aucune donnée utilisateur n'est trouvée (optionnel)
      Get.offAllNamed('/login'); // Rediriger vers la connexion si nécessaire
    }
    try {
      // Get the auth token from SharedPreferences
      final String? authToken = await SharedPref.getAuthToken(); // Assuming SharedPref is your custom class

      // Define API URL and headers
      final String apiUrl = BaseUrl+'/student-sold';
      final Map<String, String> headers = {
        'Authorization': 'Bearer $authToken', // Include the token in the headers
        'Content-Type': 'application/json',
      };

      // Make the API request
      final response = await http.get(Uri.parse(apiUrl), headers: headers);

      // Check if the response was successful
      if (response.statusCode == 200) {
        // Parse the response body
        final Map<String, dynamic> responseBody = json.decode(response.body);

        // Extract the "solde" value
        if (responseBody['success'] == true && responseBody['data'] != null) {
          final dynamic soldeValue = responseBody['data']['solde'];
          final double newSolde = soldeValue is int ? soldeValue.toDouble() : soldeValue;
          String imageUrl = responseBody['data']['photo'];
          String codeUrl = responseBody['data']['code'];
          print("imageURLd="+imageUrl);
          print("CodeURLd="+codeUrl);
          String? usavedPath = await FileUtils.downloadAndSaveImage(imageUrl, 'user_img_${DateTime.now().millisecondsSinceEpoch}.jpg');

          String? csavedPath = await FileUtils.downloadAndSaveImage(codeUrl, 'user_code__${DateTime.now().millisecondsSinceEpoch}.svg');
          if (csavedPath != null) {

            await SharedPref.saveCodeImagePath(csavedPath);
          } else {

          }

          if (usavedPath != null) {

            await SharedPref.saveProfileImagePath(usavedPath);
          } else {

          }


          // Update solde in SharedPreferences
          await SharedPref.updateSolde(newSolde);
          user.value = await SharedPref.getUserData();
          await loadimages();


        } else {
          print('API response indicates failure: ${responseBody['error']}');
        }
      } else {
        print('Failed to fetch solde. HTTP status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exceptions
      print('Error fetching solde: $e');
    }

  }

  Future<void> loadhistory({String? optionalParam}) async {
    res.value = await SharedPref.get_comp_trans_Data(); // Récupérer le token
    AllTransactions = res.value!.transactions;
    synctime.value = await SharedPref.getsynctime() ?? '';


  }


  Future<void> refreshData() async {
    // Step 1: Show loading QuickAlert (non-dismissible)
    QuickAlert.show(
      context: Get.context!,
      type: QuickAlertType.loading,
      title: 'Loading',
      text: 'Please wait while data is refreshing...',
      barrierDismissible: false,
    );

    // Step 2: Run the async method
    bool success = await loadhistoryonline();
    await loadUserData();
    await loadhistory();
    await loadrooms();

    // Step 3: Dismiss the alert using Navigator.pop
    Navigator.of(Get.context!).pop(); // this will close the alert

    // Step 4: Optionally show result
    if (success) {
      SnackbarUtils.showSuccess("Data refreshed successfully!");
    } else {
      SnackbarUtils.showError("Data refresh failed!");
    }
  }


  Future<bool> loadhistoryonline({String? optionalParam}) async {
    var authtoken = await SharedPref.getAuthToken();
    if (authtoken == null) {
      SnackbarUtils.showError("Auth token missing");
      return false;
    }

    final String apiUrl = BaseUrl + '/student-transaction-histories';
    final Map<String, String> headers = {
      'Authorization': 'Bearer $authtoken',
    };



    final Uri uri = Uri.parse(apiUrl);

    try {
      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        await SharedPref.clearhistory();
        await SharedPref.save_comp_transaction(responseData['data']);
        return true;
      } else {
        SnackbarUtils.showError("Échec de la récupération des données");
        return false;
      }
    } catch (e) {
      print("Exception: $e");
      SnackbarUtils.showError("$e");
      return false;
    }
  }

  Future<void> loadrooms({String? optionalParam}) async {
    var authtoken = await SharedPref.getAuthToken(); // Récupérer le token
    if (authtoken == null) {
      SnackbarUtils.showError(auth_token_missing); // Erreur snackbar si le token est nul
      return;
    }

    // final String apiUrl = BaseUrl + '/transaction';
    final String apiUrl = BaseUrl + '/student-room-details'; // Point de terminaison API
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
        print("Room Saved ${roomInfo.villageName}");
        await SharedPref.saveRoomsDetails(roomInfo);
      } else {
        // Gérer la réponse en cas d'erreur
        SnackbarUtils.showError("Échec de la récupération des données");
      }
    } catch (e) {
      // Gérer l'exception
      print("Une exception s'est produite : $e");
      SnackbarUtils.showError("$e");
    }
  }


  Future <void> loadimages()async {
    img.value = (await SharedPref.getProfileImagePath()) ?? '';
    qrcode.value = (await SharedPref.getCodeImagePath()) ?? '';
    // print(qrcode.value);
    // print(img.value);

  }

  Future<void> logout() async {
    bool? confirmLogout = await AlertHelper.showConfirmation(
      title: "Êtes-vous sûr ?",
      text: "Voulez-vous vraiment vous déconnecter ?",
    );

    if (confirmLogout == true) {
      await SharedPref.clear();
      Get.offAllNamed(AppRoutes.login);
    }
  }

  void changepassword() {
    //Get.offAllNamed(AppRoutes.cp);
  }

  void scanner() {
    Get.toNamed(AppRoutes.scan);
  }

  Future<void> silentrefreshData() async {
    // Step 2: Run the async method
    bool success = await loadhistoryonline();
    await loadUserData();
    await loadhistory();
    await loadrooms();
    // Step 4: Optionally show result
    if (success) {

    } else {
      SnackbarUtils.showError("Data refresh failed!");
    }
  }

  var isBalanceVisible = false.obs;

  void toggleBalanceVisibility() {
    isBalanceVisible.value = !isBalanceVisible.value;
  }
}