import 'package:get/get.dart';

import '../ui/browser/browser_screen.dart';
import '../ui/home/navigation_home_screen.dart';
import '../ui/login/login_screen.dart';
import '../ui/payout/payout_screen.dart';
import '../ui/recharge/recharge_screen.dart';
import '../ui/rooms/room_screen.dart';
import '../ui/transfer/scan_screen.dart';
import '../ui/transfer/transfer_screen.dart';




class AppRoutes {
  // Define all your app routes here
  static const String login = '/login';
  static const String home = '/home';
  // static const String cp = '/cp';
   static const String scan='/scan';
   static const String transfer='/transfer';
   static const String recharge='/recharge';
   static const String room='/room';
   static const String browser='/browser';
  static const String payout='/payout';

  static List<GetPage> routes = [
    GetPage(name: login, page: () => LoginScreen()),
    // GetPage(
    //     name: home,
    //     page: () => HomePage(),
    //     binding:BindingsBuilder((){
    //       Get.lazyPut<HomeController>(() => HomeController());
    //     })
    // ),
    GetPage(name: home, page: () => NavigationHomeScreen()),
    GetPage(name: scan, page: () => QRViewScreen()),
    GetPage(name: transfer, page: () => TransferPage()),
    GetPage(name: recharge, page: () => RechargeScreen()),
    GetPage(name: room, page: () => RoomScreen()),
    GetPage(name: browser, page: () => BrowserScreen()),
    GetPage(name: payout, page: () => PayoutScreen()),


    // Add more routes as your app grows
  ];
}