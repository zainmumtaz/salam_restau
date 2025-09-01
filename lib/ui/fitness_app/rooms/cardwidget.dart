import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../fitness_app_theme.dart';
import 'room_controller.dart';


class RoomDetailsCard extends StatelessWidget {
  final RoomController controller = Get.find<RoomController>();

  RoomDetailsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final room = controller.savedRoom.value;

      if (room == null) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: CircularProgressIndicator(),
          ),
        );
      }

      return Card(
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔹 Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF738AE6), Color(0xFF5C5EDD)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
              child: const Text(
                "Room Details",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            /// 🔹 Village
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.blue,
                child: Icon(Icons.home, color: Colors.white),
              ),
              title: const Text(
                "Village",
                style: TextStyle(
                  fontFamily: FitnessAppTheme.fontName,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  letterSpacing: 1.2,
                  color: FitnessAppTheme.darkerText,
                ),
              ),
              subtitle: Text(room.villageName ?? "N/A"),
            ),

            /// 🔹 Building
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.blue,
                child: Icon(Icons.door_front_door, color: Colors.white),
              ),
              title: const Text(
                "Building",
                style: TextStyle(
                  fontFamily: FitnessAppTheme.fontName,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  letterSpacing: 1.2,
                  color: FitnessAppTheme.darkerText,
                ),
              ),
              subtitle: Text(room.buildingName ?? "N/A"),
            ),

            /// 🔹 Room Number
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.blue,
                child: Icon(Icons.meeting_room, color: Colors.white),
              ),
              title: const Text(
                "Room Number",
                style: TextStyle(
                  fontFamily: FitnessAppTheme.fontName,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  letterSpacing: 1.2,
                  color: FitnessAppTheme.darkerText,
                ),
              ),
              subtitle: Text(room.roomNumber ?? "N/A"),
            ),

            /// 🔹 Start Date
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.blue,
                child: Icon(Icons.calendar_today, color: Colors.white),
              ),
              title: const Text(
                "Start Date",
                style: TextStyle(
                  fontFamily: FitnessAppTheme.fontName,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  letterSpacing: 1.2,
                  color: FitnessAppTheme.darkerText,
                ),
              ),
              subtitle: Text(room.startDate ?? "N/A"),
            ),

            /// 🔹 End Date
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.blue,
                child: Icon(Icons.calendar_today, color: Colors.white),
              ),
              title: const Text(
                "End Date",
                style: TextStyle(
                  fontFamily: FitnessAppTheme.fontName,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  letterSpacing: 1.2,
                  color: FitnessAppTheme.darkerText,
                ),
              ),
              subtitle: Text(room.endDate ?? "N/A"),
            ),
          ],
        ),
      );
    });
  }
}
