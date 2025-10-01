import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class BrowserController extends GetxController {
  final String url;

  BrowserController(this.url);

  @override
  void onInit() {
    super.onInit();
    _openInBrowser();
  }

  Future<void> _openInBrowser() async {
    final Uri uri = Uri.parse(url);

    try {
      if (await canLaunchUrl(uri)) {
        // ✅ Yeh line link ko default browser me khol degi
        await launchUrl(uri, mode: LaunchMode.externalApplication);

        // Optional: agar tum chaho ke screen bhi close ho jaye link open karte hi
        Get.back();
      } else {
        Get.snackbar("Error", "Browser open nahi ho saka: $url");
      }
    } catch (e) {
      Get.snackbar("Error", "Masla aaya: $e");
    }
  }
}
