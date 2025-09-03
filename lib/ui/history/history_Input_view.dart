import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';


import '../../../utilities/routes.dart';
import '../../models/transaction_model.dart';
import '../fitness_app_theme.dart';
import '../home/homecontroller.dart';
import 'historycontroller.dart';


class HistoryInputView extends StatelessWidget {
  final AnimationController? animationController;
  final Animation<double>? animation;

  const HistoryInputView({super.key, this.animationController, this.animation});

  @override
  Widget build(BuildContext context) {
    final hsc = Get.find<HistoryController>();
    final hc = Get.find<HomeController>();

    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation!,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 30 * (1.0 - animation!.value), 0.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    /// Input Card
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            blurRadius: 10.0,
                            offset: Offset(1, 2),
                          )
                        ],
                      ),
                      child: Column(
                        children: [
                          /// Type Dropdown
                          DropdownButtonFormField<int>(
                            value: hsc.selectedTypeId.value,
                            decoration: InputDecoration(
                              labelText: 'Type',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 8),
                            ),
                            items: hsc.filterTypes.map((type) {
                              return DropdownMenuItem<int>(
                                value: type.id,
                                child: Text(type.libelle ?? ''),
                              );
                            }).toList(),
                            onChanged: (val) =>
                            hsc.selectedTypeId.value = val,
                          ),
                          SizedBox(height: 10),

                          /// From Date
                          TextFormField(
                            controller: hsc.startDateController,
                            readOnly: true,
                            onTap: () => hsc.pickDate(context, true),
                            decoration: InputDecoration(
                              labelText: 'From Date',
                              suffixIcon: Icon(Icons.calendar_today),
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 10),

                          /// To Date
                          TextFormField(
                            controller: hsc.endDateController,
                            readOnly: true,
                            onTap: () => hsc.pickDate(context, false),
                            decoration: InputDecoration(
                              labelText: 'To Date',
                              suffixIcon: Icon(Icons.calendar_today),
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 16),

                          /// Filter Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                hsc.filterTransactions();
                              },
                              style: ElevatedButton.styleFrom(
                                padding:
                                EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                backgroundColor:
                                FitnessAppTheme.nearlyDarkBlue,
                              ),
                              child: Text(
                                "Filter",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// Space between form and list
                    SizedBox(height: 24),

                    /// Filtered Transactions List
                    Obx(() {
                      if (!hsc.showFilteredList.value) return const SizedBox();

                      final txList = hsc.filteredTransactions;

                      if (txList.isEmpty) {
                        return const Center(child: Text("No transactions found."));
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: txList.length,
                        //itemBuilder:(context , index){Text("test");},
                          itemBuilder: (context, index) {
                            final tx = txList[index];
                            final typeId = tx.typeId ?? 0;
                            final senderId = tx.senderId;
                            final receiverId = tx.receiverId;

                            var sign;

                            final loggedInUserId = hc.user.value!.info!.id;  // <-- Apne login ka user id yahan dalna

                            Color amountColor;

                            if (typeId == 4) {

                              if(tx.waveLaunchUrl.isEmpty)
                                {
                                  amountColor = Colors.green;
                                  sign="+";
                                }
                              else{
                                if(tx.paymentStatus.toString()=="completed"|| tx.paymentStatus.toString()=="Completed") {
                                  amountColor = Colors.green;
                                  sign = "+";
                                }
                                else{
                                  amountColor = Colors.red;
                                  sign = "";
                                }
                              }






                            } else if (typeId == 5) {
                              if (senderId == loggedInUserId) {
                                amountColor = Colors.red;
                                sign="-";
                              } else if (receiverId == loggedInUserId) {
                                amountColor = Colors.green;
                                sign="+";
                              }
                              else {
                                amountColor = Colors.grey;
                                sign="";// fallback case
                              }
                            } else if ([1, 2, 3,6].contains(typeId)) {
                              amountColor = Colors.red;
                              sign="-";
                            } else {
                              amountColor = Colors.grey;
                              sign="";// default
                            }

                            final type = tx.type ?? '';

                            final txDate = DateFormat("yyyy-MM-dd")
                                .format(DateTime.parse(tx.date.toString()));

                            return Card(
                              color: Colors.white,
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                decoration: BoxDecoration(
                                                  color: const Color(0x946BBEFB),
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                                child: Text(
                                                  type.toString().capitalize!,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text("Date: $txDate"),
                                            ],
                                          ),
                                        ),

                                        // Circle Avatar with logic-based color

                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), // text ke charon taraf space
                                          decoration: BoxDecoration(
                                            color: amountColor, // background color
                                            borderRadius: BorderRadius.circular(12), // curve amount
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            "$sign${tx.montant}",
                                            style: const TextStyle(
                                              fontSize: 18,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        )





                                      ],
                                    ),

                                    const SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        // View Button (always visible)
                                        Tooltip(
                                          message: "View Details",
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              padding: EdgeInsets.zero,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(6),
                                              ),
                                            ),
                                            onPressed: () {
                                              _showBottomSheet(context, tx, sign, amountColor);
                                            },
                                            child: Ink(
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: [Colors.blue.shade900, Colors.blue],
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                ),
                                                borderRadius: BorderRadius.circular(6),
                                              ),
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: const [
                                                    Icon(Icons.remove_red_eye, color: Colors.white, size: 18),
                                                    SizedBox(width: 6),
                                                    Text(
                                                      "View",
                                                      style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),

                                        // Agar wave_launch_url available ho tabhi button show karo
                                        if (tx.waveLaunchUrl.toString().isNotEmpty) ...[
                                          const SizedBox(width: 10),
                                          Tooltip(
                                            message: "Copy Wave Url",
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                padding: EdgeInsets.zero,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(6),
                                                ),
                                              ),
                                              onPressed: () {
                                                hsc.copyToClipboard(tx.waveLaunchUrl.toString());
                                              },
                                              child: Ink(
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors: [Colors.green.shade900, Colors.green],
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomRight,
                                                  ),
                                                  borderRadius: BorderRadius.circular(6),
                                                ),
                                                child: Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: const [
                                                      Icon(Icons.copy, color: Colors.white, size: 18),
                                                      SizedBox(width: 6),
                                                      Text(
                                                        "Copy Wave Url",
                                                        style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ],
                                    )





                                  ],
                                ),
                              ),
                            );
                          }


                      );
                    })

                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showBottomSheet(BuildContext context, TransactionModel tm,var sign, Color color) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.8,
          minChildSize: 0.4,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            return Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        margin: EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    Text(
                      (tm.type == "Recharge" || tm.typeId==6)
                          ? "Wave Payment Details (#${tm.id})"
                          : "Transaction Details",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    if (tm.typeId == 5) ...[
                      _detailRow("Type", tm.type),
                      _detailRow("Amount", "${tm.montant} XOF",
                          sign:sign.toString() ,
                          valueColor: color),
                      _detailRow("Date", tm.date ?? ""),
                      _detailRow("Sender", tm.senderName ?? ""),
                      if (tm.senderMatricule != null && tm.senderMatricule!.isNotEmpty)
                      _detailRow("Matricule", tm.senderMatricule ?? ""),
                      _detailRow("Receiver", tm.receiverName ?? ""),
                      if (tm.receiverMatricule != null && tm.receiverMatricule!.isNotEmpty)
                      _detailRow("Matricule", tm.receiverMatricule ?? ""),
                      _detailRow("Transaction ID", "#${tm.id}"),

                    ]
                    else
                    if (tm.typeId == 4) ...[
                      _detailRow("Amount", "${tm.montant} XOF",
                          valueColor: Colors.green),
                      if (tm.checkoutStatus.isNotEmpty)
                      _detailRow("Checkout Status", tm.checkoutStatus ?? ""),
                      if (tm.paymentStatus.isNotEmpty)
                      _detailRow("Payment Status", tm.paymentStatus ?? ""),
                      if (tm.waveLaunchUrl.isNotEmpty)
                        _wavedetailRow("Wave Payment URL", tm.waveLaunchUrl),
                      if (tm.whenCreated.isNotEmpty)
                      _detailRow("Created At", tm.whenCreated ?? ""),
                      if (tm.whenExpires.isNotEmpty)
                      _detailRow("Expires At", tm.whenExpires ?? ""),
                      if (tm.whenCompleted.isNotEmpty)
                      _detailRow("Completed At", tm.whenCompleted ?? "-"),
                      if (tm.date.isNotEmpty)
                        _detailRow("Date", tm.date ?? "-"),
                      if (tm.reference.isNotEmpty)
                        _detailRow("Referemce ", tm.reference ?? "-"),

                    ]
                    else
                      if (tm.typeId == 6) ...[
                        _detailRow("Amount", "-${tm.montant} XOF",
                            valueColor: Colors.red),
                        if (tm.checkoutStatus.isNotEmpty)
                          _detailRow("Checkout Status", tm.checkoutStatus ?? ""),
                        if (tm.paymentStatus.isNotEmpty)
                          _detailRow("Payment Status", tm.paymentStatus ?? ""),
                        if (tm.waveLaunchUrl.isNotEmpty)
                          _wavedetailRow("Wave Payment URL", tm.waveLaunchUrl),
                        if (tm.whenCreated.isNotEmpty)
                          _detailRow("Created At", tm.whenCreated ?? ""),
                        if (tm.whenExpires.isNotEmpty)
                          _detailRow("Expires At", tm.whenExpires ?? ""),
                        if (tm.whenCompleted.isNotEmpty)
                          _detailRow("Completed At", tm.whenCompleted ?? "-"),
                        if (tm.date.isNotEmpty)
                          _detailRow("Completed At", tm.date ?? "-"),
                        if (tm.reference.isNotEmpty)
                          _detailRow("Completed At", tm.reference ?? "-"),

                      ] else ...[
                      _detailRow("Type", tm.type),
                      _detailRow("Amount", "${tm.montant} XOF",
                          sign:sign.toString() ,
                          valueColor: color),
                      _detailRow("Date", tm.date ?? ""),


                    ]
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _detailRow(String title, String value,{String? sign,Color? valueColor}) {
    sign ??= "";
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          Flexible(
            child: Text(
              "$sign$value",
              style: TextStyle(fontWeight: FontWeight.normal, color: valueColor),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _wavedetailRow(String title, String value,{String? sign}) {
    sign ??= "";
    return  Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(width: 8),

            ],
          ),
          Flexible(

            child: TextButton(
              onPressed: () {
                if (value.isNotEmpty) {

                  Get.toNamed(AppRoutes.browser, arguments: value);
                }
              },
              child: const Text(
                "View",
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ),
        ],
      ),
    );
  }



}





