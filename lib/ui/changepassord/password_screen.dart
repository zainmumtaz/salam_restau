
import 'package:flutter/material.dart';

import 'cp_coontroller.dart';
import 'package:get/get.dart';
// Make sure this is your actual controller file

class PasswordScreen extends StatelessWidget {
  final CpController controller = Get.put(CpController());

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
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
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
                    child: Image.asset('assets/images/cpimage.png'),
                  ),

                  const SizedBox(height: 7),
                  Center(
                    child: Text(
                      'Reset Your Password',
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
                      'Please enter your current password\nand set a new one below',
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
                        _buildPasswordField(
                          label: "Current Password",
                          controller: controller.oldPasswordController,
                          error: controller.oldPasswordError.value,
                          isVisible: controller.isPasswordVisible.value,
                          toggle: controller.togglePasswordVisibility,
                          isLightMode: isLightMode,
                        ),
                        const SizedBox(height: 16),
                        _buildPasswordField(
                          label: "New Password",
                          controller: controller.newPasswordController,
                          error: controller.newPasswordError.value,
                          isVisible: controller.isPasswordVisible.value,
                          toggle: controller.togglePasswordVisibility,
                          isLightMode: isLightMode,
                        ),
                        const SizedBox(height: 16),
                        _buildPasswordField(
                          label: "Confirm Password",
                          controller: controller.confirmPasswordController,
                          error: controller.confirmPasswordError.value,
                          isVisible: controller.isPasswordVisible.value,
                          toggle: controller.togglePasswordVisibility,
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
                              onTap: controller.updatePassword,
                              borderRadius: BorderRadius.circular(4.0),
                              child: const Center(
                                child: Text(
                                  'Update Password',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                    fontSize: 18// white text for contrast
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

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required bool error,
    required bool isVisible,
    required VoidCallback toggle,
    required bool isLightMode,
  }) {
    return TextField(
      controller: controller,
      obscureText: !isVisible,
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
        suffixIcon: IconButton(
          icon: Icon(
            isVisible ? Icons.visibility : Icons.visibility_off,
            color: isLightMode ? Colors.black45 : Colors.white60,
          ),
          onPressed: toggle,
        ),
      ),
    );
  }
}

