import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:screen/screen.dart';
import '../../../constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:barcode_widget/barcode_widget.dart';

// Show the carrier barcode
class BarcodeScreen extends StatefulWidget {
  const BarcodeScreen({Key? key}) : super(key: key);
  @override
  _IdentityPageState createState() => _IdentityPageState();
}

class _IdentityPageState extends State<BarcodeScreen> {
  String barcode = "";
  //bool _isKeptOn = false;
  //double _brightness = 1.0;
  bool toggle = false;
  bool brightnessStatus = true;

  @override
  void initState() {
    super.initState();
    getBarcode();
    initPlatformState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: kPrimaryColor, actions: [
        const Icon(Icons.brightness_7),
        const SizedBox(width: 10.0),
        
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              FlutterSwitch(
                width: 55.0,
                height: 25.0,
                valueFontSize: 12.0,
                toggleSize: 18.0,
                value: brightnessStatus,
                activeColor: kSecondaryColor,
                inactiveColor: Colors.black38,
                onToggle: (val) {
                  setState(() {
                    brightnessStatus = val;
                    if(val==true){
                      Screen.setBrightness(1);
                      Screen.keepOn(true);
                    }
                    else{
                      Screen.setBrightness(-1);
                    }
                    
                  });
                },
              ),
              const SizedBox(width: 10.0),
            ]),
      ]
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
    //bool keptOn = await Screen.isKeptOn;
    double brightness = await Screen.brightness;
    setState(() {
      //_isKeptOn = keptOn;
      Screen.setBrightness(1.0);
      Screen.keepOn(true);
    });
  }
  
  @override
  void deactivate(){
    bool isBack = ModalRoute.of(context)!.isCurrent;
    if(!isBack){
      Screen.setBrightness(-1);
    }
    super.deactivate();
  }
}
