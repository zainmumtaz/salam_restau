import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'recharge_controller.dart';

class RechargeScreen extends StatelessWidget {
  final RechargeController controller = Get.put(RechargeController());

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isLightMode = brightness == Brightness.light;

    return Container(
      color: isLightMode ? Colors.white : Colors.black,
      child: SafeArea(
        top: false,
        child: Scaffold(
          backgroundColor: isLightMode ? Colors.white : Colors.black,
          body: Obx(() => SingleChildScrollView(
            keyboardDismissBehavior:
            ScrollViewKeyboardDismissBehavior.onDrag,
            child: Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top,
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header Image
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Image.asset('assets/images/rechargeimage.png'),
                  ),

                  const SizedBox(height: 7),
                  Center(
                    child: Text(
                      'Recharge',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isLightMode ? Colors.black : Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                  Center(
                    child: Text(
                      'Please select service, enter amount and optional phone number',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: isLightMode ? Colors.black : Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        // Dropdown
                        _buildDropdownField(
                          label: "Select Service",
                          isLightMode: isLightMode,
                          value: controller.selectedValue.value,
                          items: controller.dropdownItems
                              .map((item) => DropdownMenuItem<String>(
                            value: item['value'],
                            child: Text(item['label']!),
                          ))
                              .toList(),
                          onChanged: (val) =>
                          controller.selectedValue.value = val,
                        ),
                        const SizedBox(height: 16),

                        // Amount
                        _buildTextField(
                          label: "Amount",
                          controller: controller.amountController,
                          error: controller.amountError.value,
                          keyboardType: TextInputType.number,
                          isLightMode: isLightMode,
                          onChanged: controller.onAmountChanged,
                        ),
                        const SizedBox(height: 16),

                        // Phone (optional)
                        _buildTextField(
                          label: "Phone Number (Optional)",
                          controller: controller.phoneController,
                          error: false,
                          keyboardType: TextInputType.phone,
                          isLightMode: isLightMode,
                        ),
                        const SizedBox(height: 30),

                        controller.isLoading.value
                            ? const CircularProgressIndicator()
                            : Container(
                          width: 200,
                          height: 50,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF738AE6),
                                Color(0xFF5C5EDD),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(4.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.6),
                                offset: const Offset(4, 4),
                                blurRadius: 8.0,
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: controller.isFormValid
                                  ?()=> controller.rechargeNow(context)
                                  : null,
                              borderRadius: BorderRadius.circular(4.0),
                              child: const Center(
                                child: Text(
                                  'Recharge Now',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          )),
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required bool isLightMode,
    required String? value,
    required List<DropdownMenuItem<String>> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      items: items,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: isLightMode ? Colors.black87 : Colors.white70,
          fontWeight: FontWeight.w500,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required bool error,
    required bool isLightMode,
    TextInputType? keyboardType,
    ValueChanged<String>? onChanged,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      onChanged: onChanged,
      style: TextStyle(
        color: isLightMode ? Colors.black : Colors.white,
        fontSize: 16,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: isLightMode ? Colors.black87 : Colors.white70,
          fontWeight: FontWeight.w500,
        ),
        errorText: error ? "Required / Invalid" : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
