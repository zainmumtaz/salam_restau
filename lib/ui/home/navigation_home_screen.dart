
import 'package:flutter/material.dart';




import '../../../app_theme.dart';
import 'package:get/get.dart';

import '../changepassord/password_screen.dart';
import '../fitness_app_home_screen.dart';
import '../history/historycontroller.dart';
import 'drawer_user_controller.dart';
import 'home_drawer.dart';
import 'homecontroller.dart';



class NavigationHomeScreen extends StatefulWidget {
  final HomeController home_controller = Get.put(HomeController());
  final HistoryController hsc = Get.put(HistoryController());
  @override
  _NavigationHomeScreenState createState() => _NavigationHomeScreenState();
}

class _NavigationHomeScreenState extends State<NavigationHomeScreen> {
  Widget? screenView;
 DrawerIndex? drawerIndex;

  @override
  void initState() {
    drawerIndex = DrawerIndex.HOME;
    screenView = FitnessAppHomeScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.white,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          backgroundColor: AppTheme.nearlyWhite,

          body: DrawerUserController(
            screenIndex: drawerIndex,
            drawerWidth: MediaQuery.of(context).size.width * 0.75,
            onDrawerCall: (DrawerIndex drawerIndexdata) {
              changeIndex(drawerIndexdata);
              //callback from drawer for replace screen as user need with passing DrawerIndex(Enum index)
            },
            screenView: screenView,
            //we replace screen view as we need on navigate starting screens like MyHomePage, HelpScreen, FeedbackScreen, etc...
          ),
        ),
      ),
    );
  }

  void changeIndex(DrawerIndex drawerIndexdata) {
    if (drawerIndex != drawerIndexdata || drawerIndexdata == DrawerIndex.Refresh) {
      drawerIndex = drawerIndexdata;
      switch (drawerIndex) {
        case DrawerIndex.HOME:
          setState(() {
            screenView = FitnessAppHomeScreen();
          });
          break;
        case DrawerIndex.ChangePassword:
          setState(() {
            screenView = PasswordScreen();
          });
          break;
        case DrawerIndex.Refresh:
          final homeController = Get.find<HomeController>();
          homeController.refreshData();
          break;
        default:
          break;
      }
    }
  }

}
