
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import '../../../main.dart';
import '../fitness_app_theme.dart';
import 'header.dart';
import 'logincontroller.dart';

class FPScreen extends StatelessWidget {
  final LoginController controller = Get.find<LoginController>();
  FPScreen({super.key});

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
                            child: Text('Recover Password',
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

                    const Text('Student ID',
                        style: TextStyle(
                            fontFamily: FitnessAppTheme.fontName,
                            fontSize: 18,
                            fontWeight: FontWeight.w700)),
                    Obx(() => TextField(
                      controller: controller.idcontroller,
                      onChanged: (value) {
                        if (controller.sid_error.isNotEmpty) {
                          controller.sid_error.value = '';
                        }
                      },
                      decoration: InputDecoration(
                        isDense: true,
                        hintText: 'Enter Student ID',
                        hintStyle: TextStyle(
                            color: Colors.grey, fontSize: 12),
                        errorText: controller.sid_error.isNotEmpty
                            ? controller.sid_error.value
                            : null,
                      ),
                    )),

                    const SizedBox(height: 20),


                    const Text('Last Name',
                        style: TextStyle(
                            fontFamily: FitnessAppTheme.fontName,
                            fontSize: 18,
                            fontWeight: FontWeight.w700)),
                    Obx(() => TextField(
                      controller: controller.lncontroller,
                      onChanged: (value) {
                        if (controller.ln_error.isNotEmpty) {
                          controller.ln_error.value = '';
                        }
                      },
                      decoration: InputDecoration(
                        isDense: true,
                        hintText: 'Enter Last Name',
                        hintStyle: TextStyle(
                            color: Colors.grey, fontSize: 12),
                        errorText: controller.ln_error.isNotEmpty
                            ? controller.ln_error.value
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

                          controller.otprequest();

                        },
                        child: controller.isLoading.value
                            ? CircularProgressIndicator(
                          color: Colors.white,
                        )
                            : Text(
                          "Request OTP",
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
                        controller.backtologin();
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



