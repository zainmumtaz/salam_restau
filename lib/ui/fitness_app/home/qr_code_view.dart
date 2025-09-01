
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'dart:math' as math;
import '../../../main.dart';
import '../fitness_app_theme.dart';
import 'homecontroller.dart';


class QrCodeView extends StatelessWidget {
  final AnimationController? animationController;
  final Animation<double>? animation;
  final String? path;
  final double? balance;

  const QrCodeView({
    Key? key,
    this.animationController,
    this.animation,
    this.path,
    this.balance,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final qhc = Get.find<HomeController>(); // Controller access

    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation!,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 30 * (1.0 - animation!.value), 0.0),
            child: Padding(
              padding:
              const EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 18),
              child: Container(
                decoration: BoxDecoration(
                  color: FitnessAppTheme.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8.0),
                    bottomLeft: Radius.circular(8.0),
                    bottomRight: Radius.circular(8.0),
                    topRight: Radius.circular(68.0),
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: FitnessAppTheme.grey.withOpacity(0.2),
                      offset: const Offset(1.1, 1.1),
                      blurRadius: 10.0,
                    ),
                  ],
                ),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                      child: Container(
                        height: 2,
                        decoration: BoxDecoration(
                          color: FitnessAppTheme.white,
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: Center(
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final double boxSize =
                                MediaQuery.of(context).size.width * 0.9;

                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: boxSize - 150,
                                height: boxSize - 150,
                                decoration: BoxDecoration(
                                  color: FitnessAppTheme.white,
                                  borderRadius: BorderRadius.circular(0.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12.withOpacity(0.2),
                                      spreadRadius: 2,
                                      blurRadius: 6,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(0.0),
                                  child: SvgPicture.file(
                                    File(path!),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                      child: Container(
                        height: 2,
                        decoration: BoxDecoration(
                          color: FitnessAppTheme.background,
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 24, right: 24, top: 8, bottom: 16),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                const Text(
                                  'Balance',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: FitnessAppTheme.fontName,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    letterSpacing: -0.2,
                                    color: FitnessAppTheme.darkText,
                                  ),
                                ),
                                Container(
                                  width:
                                  ((70) * animation!.value),
                                  height: 4,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        HexColor('#87A0E5'),
                                        HexColor('#87A0E5')
                                            .withOpacity(0.5),
                                      ],
                                    ),
                                    borderRadius:
                                    BorderRadius.circular(4.0),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 6),
                                  child: Obx(() {
                                    return Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Obx(()=>Text(
                                          qhc.isBalanceVisible.value
                                              ? '${qhc.user.value!.info!.solde ?? 0} FCFA'
                                              : '•••••',
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontFamily: FitnessAppTheme.fontName,
                                            fontWeight: FontWeight.w900,
                                            fontSize: 20,
                                            color: FitnessAppTheme.nearlyDarkBlue,
                                          ),
                                        )),
                                        const SizedBox(width: 8),
                                        GestureDetector(
                                          onTap: qhc.toggleBalanceVisibility,
                                          child: Icon(
                                            qhc.isBalanceVisible.value
                                                ? Icons.visibility
                                                : Icons.visibility_off,
                                            size: 20,
                                            color: FitnessAppTheme.nearlyDarkBlue,
                                          ),
                                        ),
                                      ],
                                    );
                                  }),
                                ),
                                Obx(()=>Text(
                                  'Updated @ ${qhc.synctime.value.toString()}',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontFamily: FitnessAppTheme.fontName,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 9,
                                    letterSpacing: -0.2,
                                    color: FitnessAppTheme.darkText,
                                  ),
                                )),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}


