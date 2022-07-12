import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:http/http.dart' as http;
import 'package:firstapp/screens/scan/scan_model.dart';
import 'package:firstapp/database/invoice_database.dart';
import '../../../constants.dart';

class QRViewExample extends StatefulWidget {
  const QRViewExample({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  String invnum = '';
  String date = '';

  @override
  void initState() {
    super.initState();
  }

  Future<void> scanQR() async {
    String barcodeScanRes;
    int tmpdate = 0;
    String tmpString = '';

    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#007979', 'Cancel', true, ScanMode.QR);
      String random = barcodeScanRes.substring(17, 21);
      date = barcodeScanRes.substring(10, 17);
      tmpdate = int.parse(date) + 19110000;

      barcodeScanRes = barcodeScanRes.substring(0, 10);
      tmpString = tmpdate.toString().substring(0, 4) +
          '/' +
          tmpdate.toString().substring(4, 6) +
          '/' +
          tmpdate.toString().substring(6, 8);
      if (await HeaderHelper.instance
          .getScanHeader(barcodeScanRes, tmpString)) {
        barcodeScanRes = "發票已存在";
        tmpString = '';
      } else {
        http.Response response = await http.post(
            Uri.https("api.einvoice.nat.gov.tw", "PB2CAPIVAN/invapp/InvApp"),
            body: {
              "version": "0.5",
              "type": "Barcode",
              "invNum": barcodeScanRes,
              "action": "qryInvHeader",
              "generation": "V2",
              "invDate": tmpString,
              "UUID": "1000",
              "appID": "EINV0202204156709",
            });
        String responseString = response.body;

        scanModelFromJson(responseString, random);
      }
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      invnum = barcodeScanRes;
      date = tmpString;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: <Widget>[
      const SizedBox(height: 40),
      Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: <Widget>[
        GestureDetector(
          onTap: () {
            scanQR();
          },
          child: Container(
            width: 150,
            height: 150,
            decoration: const BoxDecoration(
                color: kPrimaryColor,
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const <Widget>[
                  Text(
                    "掃描",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Icon(Icons.qr_code_scanner_outlined,
                      color: Colors.white, size: 50)
                ],
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {},
          child: Container(
            width: 150,
            height: 150,
            decoration: const BoxDecoration(
                color: kSecondaryColor,
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const <Widget>[
                  Text(
                    "手動輸入",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Icon(Icons.keyboard_alt_outlined,
                      color: Colors.blueGrey, size: 50)
                ],
              ),
            ),
          ),
        )
      ]),
      Text(invnum),
      Text(date)
    ]));
  }
}
