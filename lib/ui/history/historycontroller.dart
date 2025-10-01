import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../models/filter_model.dart';
import '../../../models/response_transaction_model.dart';
import '../../../models/transaction_model.dart';
import '../../../utilities/shared_preferences.dart';




class HistoryController extends GetxController {
  var selectedDate = Rxn<DateTime>();
  var filteredTransactions = <TransactionModel>[].obs;
  var allTransactions = <TransactionModel>[].obs;
  var res = Rxn<ResponseTransactionModel>();

  var selectedFilterIndex = 0.obs;
  var selectedTypeId = RxnInt();
  var filterTypes = <FilterModel>[].obs;

  // Date range filter values
  Rxn<DateTime> fromDate = Rxn<DateTime>();
  Rxn<DateTime> toDate = Rxn<DateTime>();

  // Controllers for date fields
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();

  var isLoading = false.obs;
  var showFilteredList = false.obs;
  var lastSyncTime = ''.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    await loadHistory();
  }

  Future<void> loadHistory() async {
    isLoading.value = true;
    res.value = await SharedPref.get_comp_trans_Data();
    allTransactions.assignAll(res.value!.transactions);
    filterTypes.assignAll(res.value!.filtre);


    // Agar filter pehle se active hai to wapis run karo
    if (showFilteredList.value) {
      filterTransactions();
    }

    isLoading.value = false;
  }

  Future<void> loadFromLocal() async {
    try {
      ResponseTransactionModel? model = await SharedPref.get_comp_trans_Data();
      if (model != null) {
        // Agar tumhare paas list hai to yahan convert karo
       // allTransactions.assignAll([model.transactions]);
      }

    } catch (e) {

    }
  }

  void filterTransactions() {
    final fromText = startDateController.text.trim();
    final toText = endDateController.text.trim();
    final selectedId = selectedTypeId.value;

    DateTime? from;
    DateTime? to;

    if (fromText.isNotEmpty) {
      from = DateTime.tryParse(fromText);
    }
    if (toText.isNotEmpty) {
      to = DateTime.tryParse(toText);
    }

    final filtered = allTransactions.where((tx) {
      final txDate = DateTime.tryParse(tx.date);

      final matchType = selectedId == null || tx.typeId == selectedId;
      final matchFrom = from == null || (txDate != null && txDate.isAfter(from.subtract(Duration(days: 1))));
      final matchTo = to == null || (txDate != null && txDate.isBefore(to.add(Duration(days: 1))));

      return matchType && matchFrom && matchTo;
    }).toList();


    filteredTransactions.assignAll(filtered);

    showFilteredList.value = true;
  }

  void copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text)).then((_) {
      Get.snackbar(
        "Copied",
        "Text copied to clipboard",
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    });
  }

  void selectFilter(int index) {
    selectedFilterIndex.value = index;

  }

  Future<void> pickDate(BuildContext context, bool isFromDate) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      if (isFromDate) {
        fromDate.value = picked;
        startDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      } else {
        toDate.value = picked;
        endDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      }


    }
  }

  Future<void> openInBrowser(String url) async {
    final Uri uri = Uri.parse(url);

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      print("Error opening browser: $e");
    }
  }
}


