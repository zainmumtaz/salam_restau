
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import '../../../main.dart';
import '../fitness_app_theme.dart';
import 'header.dart';
import 'logincontroller.dart';

class RPScreen extends StatelessWidget {
  final LoginController controller = Get.find<LoginController>();
  RPScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Remove backgroundColor here
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              FitnessAppTheme.nearlyDarkBlue,
              HexColor('#6A88E5'),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              const SliverAppBar(
                backgroundColor: Colors.transparent, // Transparent to show gradient
                expandedHeight: 200,
                floating: false,
                flexibleSpace: FlexibleSpaceBar(
                  background: Header(
                    title: 'Salam Restau',
                    imagePath: 'assets/images/vector.jpg',
                  ),
                ),
              ),
            ];
          },
          body: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 40, 15, 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(color: Colors.grey, width: 75, height: 1),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text('Reset Password',
                              style: TextStyle(
                                fontFamily: FitnessAppTheme.fontName,
                                fontWeight: FontWeight.w700,
                                fontSize: 18 ,
                                letterSpacing: 1.2,
                                color: FitnessAppTheme.darkerText,
                              ),
                            ),
                          ),
                          Container(color: Colors.grey, width: 75, height: 1),
                        ],
                      ),
                    ),

                    const Text('OTP',
                        style: TextStyle(
                            fontFamily: FitnessAppTheme.fontName,
                            fontSize: 18,
                            fontWeight: FontWeight.w700)),
                    Obx(() => TextField(
                      controller: controller.otpcontroller,
                      onChanged: (value) {
                        if (controller.otp_error.isNotEmpty) {
                          controller.otp_error.value = '';
                        }
                      },
                      decoration: InputDecoration(
                        isDense: true,
                        hintText: 'Enter OTP',
                        hintStyle: TextStyle(
                            color: Colors.grey, fontSize: 12),
                        errorText: controller.otp_error.isNotEmpty
                            ? controller.otp_error.value
                            : null,
                      ),
                    )),

                    const SizedBox(height: 20),


                    const Text('New Password',
                        style: TextStyle(
                            fontFamily: FitnessAppTheme.fontName,
                            fontSize: 18,
                            fontWeight: FontWeight.w700)),
                    Obx(() => TextField(
                      controller: controller.newpasscontroller,
                      onChanged: (value) {
                        if (controller.newpass_error.isNotEmpty) {
                          controller.newpass_error.value = '';
                        }
                      },
                      decoration: InputDecoration(
                        isDense: true,
                        hintText: 'Enter New Password',
                        hintStyle: TextStyle(
                            color: Colors.grey, fontSize: 12),
                        errorText: controller.newpass_error.isNotEmpty
                            ? controller.newpass_error.value
                            : null,
                      ),
                    )),


                    const SizedBox(height: 20),


                    const Text('Confirm Password',
                        style: TextStyle(
                            fontFamily: FitnessAppTheme.fontName,
                            fontSize: 18,
                            fontWeight: FontWeight.w700)),
                    Obx(() => TextField(
                      controller: controller.conpasscontroller,
                      onChanged: (value) {
                        if (controller.conpass_error.isNotEmpty) {
                          controller.conpass_error.value = '';
                        }
                      },
                      decoration: InputDecoration(
                        isDense: true,
                        hintText: 'Confirm Password',
                        hintStyle: TextStyle(
                            color: Colors.grey, fontSize: 12),
                        errorText: controller.conpass_error.isNotEmpty
                            ? controller.conpass_error.value
                            : null,
                      ),
                    )),

                    const SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        color: FitnessAppTheme.nearlyDarkBlue,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      child:Obx(()=>TextButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : () {

                          controller.resetpasword();

                        },
                        child: controller.isLoading.value
                            ? CircularProgressIndicator(
                          color: Colors.white,
                        )
                            : Text(
                          "Save",
                          style: const TextStyle(
                            fontFamily: FitnessAppTheme.fontName,
                            fontWeight: FontWeight.w700,
                            fontSize: 22 ,
                            letterSpacing: 1.2,
                            color: FitnessAppTheme.white,),
                        ),
                      )),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: (){
                        controller.login();
                      },
                      child: Text('Back To Login',
                        style: TextStyle(
                          fontFamily: FitnessAppTheme.fontName,
                          fontWeight: FontWeight.w700,
                          fontSize: 16 ,
                          letterSpacing: 1.2,
                          color: FitnessAppTheme.darkerText,
                        ),
                      ),
                    )


                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}



