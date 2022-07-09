import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:screen/screen.dart';
import '../../../constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:barcode_widget/barcode_widget.dart';
//import 'package:wakelock/wakelock.dart';

// Show the carrier barcode
class BarcodeScreen extends StatefulWidget {
  const BarcodeScreen({Key? key}) : super(key: key);
  @override
  _IdentityPageState createState() => _IdentityPageState();
}

class _IdentityPageState extends State<BarcodeScreen> {
  String barcode = "";
  bool _isKeptOn = false;
  double _brightness = 1.0;
  bool toggle = false;
  bool drinkingStatus = false;

  @override
  void initState() {
    super.initState();
    getBarcode();
    initPlatformState();
    //Wakelock.enable(); //Make the screen light.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor, 
        actions: [
          Icon(Icons.brightness_7),
          SizedBox(width: 10.0),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                FlutterSwitch(
                  width: 55.0,
                  height: 25.0,
                  valueFontSize: 12.0,
                  toggleSize: 18.0,
                  value: drinkingStatus,
                  activeColor: kSecondaryColor,
                  inactiveColor: Colors.black38,
                  onToggle: (val) {
                    setState(() {
                      drinkingStatus = val;
                    });
                  },
                ),
                SizedBox(width: 10.0),
              ]
            ),
          ]
          //title: Text("第二頁"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            BarcodeWidget(
              barcode: Barcode.code39(),
              data: barcode,
              width: 300,
              height: 100,
              errorBuilder: (context, error) => Center(child: Text(error)),
            ),

            /*
            AnimatedCrossFade(
              firstChild: const Icon(Icons.brightness_7, size: 35),
              secondChild: const Icon(Icons.brightness_3, size: 35),
              crossFadeState:
                  toggle ? CrossFadeState.showSecond : CrossFadeState.showFirst,
              duration: Duration(seconds: 1),
            ),
            Slider(
                value: _brightness,
                onChanged: (double b) {
                  setState(() {
                    _brightness = b;
                  });
                  Screen.setBrightness(b);
                })*/
          ],
        ),
      ),
    );
  }

  Future<void> getBarcode() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    barcode = pref.getString('barcode')!;
    setState(() {});
  }

  initPlatformState() async {
    bool keptOn = await Screen.isKeptOn;
    double brightness = await Screen.brightness;
    setState(() {
      _isKeptOn = keptOn;
      _brightness = brightness;
    });
  }
}
