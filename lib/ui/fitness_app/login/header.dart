import 'package:flutter/material.dart';
import 'package:salam_restau/ui/fitness_app/fitness_app_theme.dart';

import '../../../main.dart';



class Header extends StatelessWidget {
  final String title;
  final String imagePath;

  const Header({
    Key? key,
    required this.title,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: double.infinity,
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
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // Avatar image above title
          Positioned(
            top: 50,
            child: CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(imagePath), // Or use NetworkImage
            ),
          ),

          // Centered title below avatar
          Positioned(
            top: 160,
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontFamily: 'Quicksand',
                fontSize: 32,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
