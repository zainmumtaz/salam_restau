import 'package:flutter/material.dart';


import '../../../main.dart';
import '../fitness_app_theme.dart';



class Header extends StatelessWidget {
  final String title;
  final String imagePath;

  const Header({
    super.key,
    required this.title,
    required this.imagePath,
  });

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
