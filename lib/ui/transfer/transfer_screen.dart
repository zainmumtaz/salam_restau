import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'transfer_controller.dart';



class TransferPage extends StatelessWidget {
  final TransferController tc = Get.put(TransferController());

  @override
  Widget build(BuildContext context) {


    if (tc.sm.value == null && !tc.isLoading.value && !tc.isQRCodeValidated.value) {
      WidgetsBinding.instance.addPostFrameCallback((_) => tc.validateQRCode());
    }

    return Scaffold(
      appBar: AppBar(title: Text("Transfert Page")),
      body: Obx(() {
        if (tc.isLoading.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text("Verifying QR code..."),
              ],
            ),
          );
        }

        if (tc.sm.value == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Student not found or invalid QR code!", style: TextStyle(color: Colors.red)),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Get.back(),
                  child: Text("Go Back"),
                ),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              CircleAvatar(
                radius: 100,
                backgroundColor: Colors.black,
                backgroundImage: tc.sm.value?.photo != null
                    ? NetworkImage(tc.sm.value!.photo)
                    : null,
              ),
              SizedBox(height: 10),
              Text(tc.sm.value?.nomComplet ?? "", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text(tc.sm.value!.matricule, style: TextStyle(fontSize: 16)),

              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Montant", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Obx(() => TextField(
                      controller: tc.textController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Entrez le Montant",
                        border: OutlineInputBorder(),
                        errorText: tc.errorText.value,
                      ),
                      onChanged: (value) => tc.validateInput(value),
                    )),
                    SizedBox(height: 20),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SizedBox(
                    width: double.infinity,
                    child: Obx(() => ElevatedButton(
                      onPressed: tc.isSubmitting.value
                          ? null
                          : () => tc.confirmTransfer(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: tc.isSubmitting.value
                          ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                          : Text(
                        "Soumettre",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    )),
                  ),
                ),

                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
