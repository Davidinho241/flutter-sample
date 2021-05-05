import 'dart:io';
import 'package:coinpay/src/utils/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_svg/svg.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:coinpay/src/helpers/localization.dart';
import 'package:coinpay/src/utils/sizes.dart';
import 'package:coinpay/src/widgets/texts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class QrCodeScanUI extends StatefulWidget {
  const QrCodeScanUI({Key key}) : super(key: key);
  @override
  _QrCodeScanUIState createState() => _QrCodeScanUIState();
}

class _QrCodeScanUIState extends State<QrCodeScanUI> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController qrCodeController;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      qrCodeController?.pauseCamera();
    } else if (Platform.isIOS) {
      qrCodeController?.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    var lang = AppLocalizations.of(context);
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
        MediaQuery.of(context).size.height < 400)
        ? 300.0
        : 400.0;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: TextTitle(
          data: "${lang.translate('screen.transactionScreen.appBarQrCodeScan')}",
          height: Sizes.s1,
          size: FontSize.s25,
          weight: FontWeight.w600,
          textAlign: TextAlign.center,
        ),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(''),
          icon: Icon(
              Icons.arrow_back_ios
          ),
        ),
        actions: [
          SvgPicture.asset(
            "assets/images/icons/ScanIcon.svg",
            color: secondaryColor,
          ),
          SizedBox(
            width: Sizes.s5,
          )
        ],
      ),
      body: QRView(
        key: qrKey,
        onQRViewCreated: (QRViewController controller) {
          setState(() {
            qrCodeController = controller;
          });
          controller.scannedDataStream.listen((scanData) {
            print(scanData.code);
            qrCodeController.stopCamera();
            Navigator.of(context).pop(scanData.code);
          });
        },
        overlay: QrScannerOverlayShape(
          borderColor: secondaryColor,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea
        ),
      ),
    );
  }

  @override
  void dispose() {
    qrCodeController?.dispose();
    super.dispose();
  }
}

