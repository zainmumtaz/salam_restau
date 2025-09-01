
import 'package:get/get.dart';
import 'filter_model.dart';
import 'transaction_model.dart';
class ResponseTransactionModel {
  // Reactive fields
  final RxList<TransactionModel> transactions;
  final RxList<FilterModel> filtre;

  // Constructor
  ResponseTransactionModel({
    required List<TransactionModel> transactions,
    required List<FilterModel> filtre,
  })  : transactions = RxList(transactions),
        filtre = RxList(filtre);

  // Factory method for JSON parsing
  factory ResponseTransactionModel.fromJson(Map<String, dynamic> json) {
    return ResponseTransactionModel(
      transactions: (json["transactions"] is List)
          ? (json["transactions"] as List)
          .map((item) => TransactionModel.fromJson(item))
          .toList()
          : <TransactionModel>[],
      filtre: (json["filtre"] is List)
          ? (json["filtre"] as List)
          .map((item) => FilterModel.fromJson(item))
          .toList()
          : <FilterModel>[],
    );
  }


}
