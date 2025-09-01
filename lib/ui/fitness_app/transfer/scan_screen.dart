import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:salam_restau/utilities/snack_alerts.dart';

import '../../../utilities/routes.dart';

class QRViewScreen extends StatefulWidget {

  const QRViewScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewScreenState();
}

class _QRViewScreenState extends State<QRViewScreen> {


  Barcode? result;

  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');





  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Scanner le numero du destinataire',
          style: TextStyle(
            fontSize: 16, // Set the text size to 18
          ),
        ),

        // Default back button will appear
      ),
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
          Container(
            color: Colors.black, // Black strip at the bottom
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                // Flash Toggle Icon
                IconButton(
                  icon: Icon(Icons.flash_on, color: Colors.white, size: 30), // Increased size
                  onPressed: () async {
                    await controller?.toggleFlash();

                  },
                ),
                // Cancel Icon
                IconButton(
                  icon: Icon(Icons.cancel, color: Colors.white, size: 30), // Increased size
                  onPressed: () {

                    Navigator.pop(context);
                    // Close the screen
                  },
                ),
                // Camera Flip Icon
                IconButton(
                  icon: Icon(Icons.flip_camera_android, color: Colors.white, size: 30), // Increased size
                  onPressed: () async {
                    await controller?.flipCamera();
                  },
                ),
              ],
            ),
          ),
        ],
      ),



    );
  }

  Widget _buildQrView(BuildContext context) {

    var scanArea = (MediaQuery.of(context).size.width)-50;

    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });

    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        if(result!=null)
        {

          controller?.pauseCamera();
           var qrdata = result!.code;
          // qrdata="\$2y\$10\$BMjUs0zhi4MilwaLhCrwre8HRO5BGMH2ExrNqKh5rQtseX7V3wud2";

          SnackbarUtils.showSuccess(qrdata.toString());
          Get.offNamed(AppRoutes.transfer, arguments: {'qrdata': qrdata});
          // sc.transfer();


        }




      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    // log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
    //  var qrdata="\$2y\$10\$BMjUs0zhi4MilwaLhCrwre8HRO5BGMH2ExrNqKh5rQtseX7V3wud2";
    // Get.offNamed(AppRoutes.transfer, arguments: {'qrdata': qrdata});
  }





}