import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:http/http.dart' as http;
import 'package:firstapp/database/invoice_database.dart';
import 'package:firstapp/screens/scan/add_invoice.dart';
import '../../../constants.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:firstapp/database/details_database.dart';
import 'dart:math';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class QRViewExample extends StatefulWidget {
  const QRViewExample({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  String invnum = '點選上方掃描或輸入';
  String date = 'xxxx/xx/xx';
  String seller = 'xxxx';
  String amount = 'xx';

  @override
  void initState() {
    super.initState();
  }

  Future<void> scanQR() async {
    String barcodeScanRes;
    int tmpdate = 0;
    String tmpString = 'xxxx/xx/xx';
    String tmpseller = 'xxxx';
    String tmpamount = 'xx';
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String? barcode = pref.getString('barcode') ?? "";
    var rng = Random();
    int uuid = rng.nextInt(1000);
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
        tmpString = 'xxxx/xx/xx';
        showTopSnackBar(
          context,
          const CustomSnackBar.info(
            message: "發票已存在",
            backgroundColor: kSecondaryColor,
          ),
        );
      } else {
        var client = http.Client();
        try {
          var response = await client.post(
              Uri.https("api.einvoice.nat.gov.tw", "PB2CAPIVAN/invapp/InvApp"),
              body: {
                "version": "0.5",
                "type": "Barcode",
                "invNum": barcodeScanRes,
                "action": "qryInvHeader",
                "generation": "V2",
                "invDate": tmpString,
                "UUID": uuid.toString(),
                "appID": "EINV0202204156709",
              });

          if (response.statusCode == 200) {
            String responseString = response.body;
            var r = jsonDecode(responseString);

            final SharedPreferences pref =
                await SharedPreferences.getInstance();
            String? barcode = pref.getString('barcode') ?? "";
            uuid = rng.nextInt(1000);

            String tmpdate = r['invDate'].substring(0, 4) +
                '/' +
                r['invDate'].toString().substring(4, 6) +
                '/' +
                r['invDate'].toString().substring(6, 8);

            int tmpyear = int.parse(tmpdate.substring(0, 4)) - 1911;
            int tmpmonth = int.parse(tmpdate.substring(5, 7));
            String tag = tmpyear.toString() + tmpdate.substring(5, 7);
            String tmptag;
            if (tmpmonth % 2 != 0) {
              tmptag = (int.parse(tag) + 1).toString();
            } else {
              tmptag = tag;
            }

            int amount = 0;
            try {
              var response2 = await client.post(
                  Uri.https(
                      "api.einvoice.nat.gov.tw", "PB2CAPIVAN/invapp/InvApp"),
                  body: {
                    "version": "0.5",
                    "type": "Barcode",
                    "invNum": r['invNum'].toString(),
                    "action": "qryInvDetail",
                    "generation": "V2",
                    "invTerm": tmptag,
                    "invDate": tmpdate,
                    "encrypt": "11",
                    "sellerID": "11",
                    "UUID": uuid.toString(),
                    "randomNumber": random,
                    "appID": "EINV0202204156709",
                  });
              if (response2.statusCode == 200) {
                String responseString2 = response2.body;
                var r2 = jsonDecode(responseString2);
                List d2 = r2['details'];

                List<String> splitted;
                if (tag[3] == "0") {
                  tag = tag.substring(0, 3) + tag.substring(4, 5);
                }
                for (var dde in d2) {
                  splitted = dde['quantity'].split('.');
                  await DetailHelper.instance.add(invoice_details(
                      tag: tag,
                      invNum: r['invNum'],
                      name: dde['description'],
                      date: tmpdate,
                      quantity: splitted[0],
                      amount: dde['amount']));

                  amount += int.parse(dde['amount']);
                }

                await HeaderHelper.instance.add(Header(
                    tag: tag,
                    date: tmpdate,
                    time: r['invoiceTime'],
                    seller: r['sellerName'],
                    address: r['sellerAddress'],
                    invNum: r['invNum'],
                    barcode: "Scan",
                    amount: amount.toString(),
                    w: 'f'));

                tmpseller = r['sellerName'];
                tmpamount = amount.toString();
              }
            } catch (e) {
              print("error");
            }

            showTopSnackBar(
              context,
              const CustomSnackBar.success(
                message: "掃描成功",
                backgroundColor: kSecondaryColor,
              ),
            );
          }
        } catch (e) {
          print("error");
        }

        client.close();
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
      seller = tmpseller;
      amount = tmpamount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: <Widget>[
      const SizedBox(height: 70),
      Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: <Widget>[
        GestureDetector(
          onTap: () {
            scanQR();
          },
          child: Neumorphic(
            style: NeumorphicStyle(
                shape: NeumorphicShape.concave,
                intensity: 0.9,
                boxShape:
                    NeumorphicBoxShape.roundRect(BorderRadius.circular(25)),
                depth: 10,
                lightSource: LightSource.topRight,
                color: kPrimaryColor),
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const <Widget>[
                  Text(
                    "掃描輸入",
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
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddInvoice(),
              ),
            );
          },
          child: Neumorphic(
            style: NeumorphicStyle(
                shape: NeumorphicShape.concave,
                intensity: 0.9,
                boxShape:
                    NeumorphicBoxShape.roundRect(BorderRadius.circular(25)),
                depth: 10,
                lightSource: LightSource.topRight,
                color: const Color.fromARGB(255, 207, 219, 235)),
            child: Padding(
              padding: const EdgeInsets.all(28),
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
      const SizedBox(height: 100),
      Container(
          height: 145,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(20.0)),
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 10.0),
              ]),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            invnum,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '   ' + date + '   ',
                            style: const TextStyle(
                                fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                        ]),
                    Text(
                      seller,
                      style: const TextStyle(fontSize: 11, color: Colors.black),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "\$" + amount,
                      style: const TextStyle(
                          fontSize: 25,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                Image.asset(
                  "assets/images/image_1.png",
                  height: 50,
                )
              ],
            ),
          )),
    ]));
  }
}
