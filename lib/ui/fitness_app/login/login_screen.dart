import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:salam_restau/ui/fitness_app/fitness_app_theme.dart';
import 'package:get/get.dart';
import '../../../main.dart';
import 'header.dart';
import 'logincontroller.dart';

class LoginScreen extends StatelessWidget {
  final LoginController controller = Get.find<LoginController>();
  LoginScreen({super.key});

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
                            child: Text('Please Login',
                              style: TextStyle(
                                fontFamily: FitnessAppTheme.fontName,
                                fontWeight: FontWeight.w700,
                                fontSize: 22 ,
                                letterSpacing: 1.2,
                                color: FitnessAppTheme.darkerText,
                              ),
                            ),
                          ),
                          Container(color: Colors.grey, width: 75, height: 1),
                        ],
                      ),
                    ),

                    const Text('Matricule',
                        style: TextStyle(
                            fontFamily: FitnessAppTheme.fontName,
                            fontSize: 18,
                            fontWeight: FontWeight.w700)),
                    Obx(() => TextField(
                      controller: controller.matriculeController,
                      onChanged: (value) {
                        if (controller.matriculeError.isNotEmpty) {
                          controller.matriculeError.value = '';
                        }
                      },
                      decoration: InputDecoration(
                        isDense: true,
                        hintText: 'Votre matricule identifiant',
                        hintStyle: TextStyle(
                            color: Colors.grey, fontSize: 12),
                        errorText: controller.matriculeError.isNotEmpty
                            ? controller.matriculeError.value
                            : null,
                      ),
                    )),
                    const SizedBox(height: 20),
                    const Text('Password',
                        style: TextStyle(
                            fontFamily: 'Quicksand',
                            fontSize: 18,
                            fontWeight: FontWeight.w700)),
                    Obx(()=>TextField(
                      controller: controller.passwordController,
                      obscureText: !controller.isPasswordVisible.value,
                      decoration: InputDecoration(
                        hintText: 'Votre password',
                        hintStyle:
                        const TextStyle(color: Colors.grey, fontSize: 12),
                        suffixIcon: IconButton(
                          icon: Icon(
                            controller.isPasswordVisible.value
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            controller.togglePasswordVisibility();
                          },
                        ),
                        errorText: controller.passwordError.isNotEmpty
                            ? controller.passwordError.value
                            : null,
                      ),
                    ),),
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

                          controller.login();

                        },
                        child: controller.isLoading.value
                            ? CircularProgressIndicator(
                          color: Colors.white,
                        )
                            : Text(
                          "Se connecter",
                          style: const TextStyle(
                            fontFamily: FitnessAppTheme.fontName,
                            fontWeight: FontWeight.w700,
                            fontSize: 22 ,
                            letterSpacing: 1.2,
                            color: FitnessAppTheme.white,),
                        ),
                      )),
                    ),


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



