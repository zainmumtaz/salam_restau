import 'package:salam_restau/utilities/routes.dart';

class MealsListData {
  MealsListData({
    this.imagePath = '',
    this.titleTxt = '',
    this.startColor = '',
    this.endColor = '',
    this.meals,
    this.kacl = 0,
    this.route='',
  });

  String imagePath;
  String titleTxt;
  String startColor;
  String endColor;
  List<String>? meals;
  int kacl;
  String route;

  static List<MealsListData> tabIconsList = <MealsListData>[
    MealsListData(
      imagePath: 'assets/myapp/transfer.png',
      titleTxt: 'Transfer',
      kacl: 0,
      meals: <String>['Share Balance'],
      startColor: '#FA7D82',
      endColor: '#FFB295',
      route: AppRoutes.scan,
    ),
    MealsListData(
      imagePath: 'assets/myapp/payment.png',
      titleTxt: 'Payments',
      kacl: 0,
      meals: <String>['Recharge'],
      startColor: '#738AE6',
      endColor: '#5C5EDD',
      route: AppRoutes.recharge,
    ),
    MealsListData(
      imagePath: 'assets/myapp/credits.png',
      titleTxt: 'Payout',
      kacl: 0,
      meals: <String>['Withdrawals'],
      startColor: '#009688',
      endColor: '#4CAF50',
      route: AppRoutes.payout,
    ),
    MealsListData(
      imagePath: 'assets/myapp/banque.png',
      titleTxt: 'Rooms',
      kacl: 0,
      meals: <String>['Rooms'],
      startColor: '#FE95B6',
      endColor: '#FF5287',
      route: AppRoutes.room,
    ),
    // MealsListData(
    //   imagePath: 'assets/myapp/credits.png',
    //   titleTxt: 'Credits',
    //   kacl: 0,
    //   meals: <String>['Recommend:', '800 kcal'],
    //   startColor: '#FE95B6',
    //   endColor: '#FF5287',
    // ),
    // MealsListData(
    //   imagePath: 'assets/myapp/banque.png',
    //   titleTxt: 'Banque',
    //   kacl: 0,
    //   meals: <String>['Recommend:', '703 kcal'],
    //   startColor: '#6F72CA',
    //   endColor: '#1E1466',
    // ),
    //
    // MealsListData(
    //   imagePath: 'assets/myapp/cadeaux.png',
    //   titleTxt: 'Cadeaux',
    //   kacl: 0,
    //   meals: <String>['Recommend:', '703 kcal'],
    //   startColor: '#009688', // Teal 500
    //   endColor: '#4CAF50',
    //   route: AppRoutes.scan,
    // ),
    //
    // MealsListData(
    //   imagePath: 'assets/fitness_app/dinner.png',
    //   titleTxt: 'Coffre',
    //   kacl: 0,
    //   meals: <String>['Recommend:', '703 kcal'],
    //   startColor: '#3F51B5',
    //   endColor: '#2196F3',
    // ),
    // MealsListData(
    //   imagePath: 'assets/myapp/transport.png',
    //   titleTxt: 'Transport',
    //   kacl: 0,
    //   meals: <String>['Recommend:', '703 kcal'],
    //     startColor: '#F57C00', // Orange 700
    //     endColor: '#FFC107'
    // )
  ];
}
