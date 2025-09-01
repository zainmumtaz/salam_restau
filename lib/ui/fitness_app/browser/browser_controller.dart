import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BrowserController extends GetxController {
  final String url;
  late final WebViewController webViewController;

  var isLoading = true.obs;

  BrowserController(this.url);

  @override
  void onInit() {
    super.onInit();
    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (uri) {
            isLoading.value = false;
          },
        ),
      )
      ..loadRequest(Uri.parse(url));
  }
}