import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../models/filter_model.dart';
import '../../../models/response_transaction_model.dart';
import '../../../models/transaction_model.dart';
import '../../../utilities/shared_preferences.dart';




class RoomDetailsController extends GetxController {
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
    allTransactions=res.value!.transactions;
    filterTypes=res.value!.filtre;

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
      print("Error loading from local: $e");
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
    filteredTransactions.forEach((t) {
      print("${t.typeId}- ${t.type}- ${t.date}");
    });
    showFilteredList.value = true;
  }

  void selectFilter(int index) {
    selectedFilterIndex.value = index;
    filterTransactions();
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

      filterTransactions();
    }
  }
}


