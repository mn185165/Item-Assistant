import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'item.dart';
import 'scanItemPageModel.dart';

class ScanItemPage extends StatelessWidget {
  final model = new ScanItemPageModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Scan Item')), body: ScanView(this.model));
  }
}

class ScanView extends StatefulWidget {
  final ScanItemPageModel model;

  ScanView(this.model);

  @override
  State<StatefulWidget> createState() => _ScanViewState();
}

class _ScanViewState extends State<ScanView> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  String status = "Scan an item";
  // TODO: Fix this!
  Item? item;
  // Item? item = new Item(
  //     "ps5",
  //     "Sony Playstation 5",
  //     "Sony Playstation 5 Disc Version with Extra DualSense Wireless Controller",
  //     "B5",
  //     "\$ 1,200",
  //     "https://firebasestorage.googleapis.com/v0/b/hackathon-b319a.appspot.com/o/ps5.png?alt=media&token=0d40a75e-8d55-44f8-8fad-6998697310d0",
  //     true);

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() async {
    super.reassemble();
    if (Platform.isAndroid) {
      await controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        buildQrView(context),
        Positioned(
            bottom: 50,
            child: Container(
                width: MediaQuery.of(context).size.width,
                child: buildFooter())),
        Positioned(bottom: 120, child: buildResult())
      ],
    );
  }

  Widget buildFooter() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Spacer(),
        Container(
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30), color: Colors.white60),
            child: IconButton(
              icon: FutureBuilder<bool?>(
                future: controller?.getFlashStatus(),
                builder: (context, snapshot) {
                  if (snapshot.data != null) {
                    return Icon(
                        snapshot.data! ? Icons.flash_on : Icons.flash_off);
                  } else {
                    return Icon(Icons.flash_off);
                  }
                },
              ),
              onPressed: () async {
                await controller?.toggleFlash();
                setState(() {});
              },
            )),
        Spacer(),
        buildItemButton(),
        Spacer(),
        Container(
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30), color: Colors.white60),
            child: IconButton(
              icon: FutureBuilder(
                future: controller?.getCameraInfo(),
                builder: (context, snapshot) {
                  if (snapshot.data != null) {
                    return Icon(Icons.switch_camera);
                  } else {
                    return Container();
                  }
                },
              ),
              onPressed: () async {
                await controller?.flipCamera();
                setState(() {});
              },
            )),
        Spacer()
      ],
    );
  }

  Widget buildItemButton() {
    return Opacity(
        opacity: this.item == null ? 0.0 : 1.0,
        child: Container(
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30), color: Colors.white60),
            child: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () => {
                      widget.model.itemButtonClicked(context, this.item!),
                      setState(() {
                        this.item = null;
                        this.status = "Scan an item";
                      })
                    })));
  }

  Widget buildResult() {
    return Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8), color: Colors.white60),
        child: Text(this.status));
  }

  Widget buildQrView(BuildContext context) {
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.green,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: MediaQuery.of(context).size.width * 0.7),
      // onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      if (scanData != this.result) {
        setState(() {
          this.result = scanData;
          widget.model.getItem(this.result!.code).then((value) => {
                if (value == null)
                  {this.status = "Item not found", this.item = null}
                else
                  {
                    this.item = value,
                    this.status = "Item found: " + this.item!.name
                  }
              });
        });
      }
    });
  }

  // void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
  //   log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
  //   if (!p) {
  //     // ScaffoldMessenger.of(context).showSnackBar(
  //     //   SnackBar(content: Text('no Permission')),
  //     // );
  //   }
  // }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
