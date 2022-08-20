import 'package:flutter/material.dart';
import '../../../constants.dart';

import 'package:flutter_switch/flutter_switch.dart';
import 'package:group_button/group_button.dart';

// Notifying the user to drink water
/*
目前只做到出現那個switch的樣子，還需要將他移到右側
未完成的部分有：
  1. 將switch按鈕移到右側
  2. 設定時間，像一般設定鬧鐘一樣
  3. 跳出提醒
*/
class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);
  @override
  _IdentityPageState createState() => _IdentityPageState();
}

class _IdentityPageState extends State<NotificationScreen> {
  bool drinkingStatus = false; // on or off, it need to be saved in sharepreference
  final controller = GroupButtonController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        /*
        title: Text(
          "FlutterSwitch Demo",
          style: TextStyle(color: Colors.white),
        ),
        */
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 20.0),
              const Text("喝水提醒"),
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlutterSwitch(
                    width: 55.0,
                    height: 25.0,
                    valueFontSize: 12.0,
                    toggleSize: 18.0,
                    value: drinkingStatus,
                    activeColor: kPrimaryColor,
                    inactiveColor: Colors.black38,
                    onToggle: (val) {
                      setState(() {
                        drinkingStatus = val;
                      });
                    },
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "Value: $drinkingStatus",
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30.0),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const <Widget>[
                    GroupButton(
                      isRadio: false,
                      buttons: [
                        "10:00",
                        "12:00",
                        "14:00"
                      ],
                    ),
                    /*
                    TextButton(
                      onPressed: () => controller.selectIndex(1),
                      child: const Text('Select 1 button'),
                    )
                    */
                  ]),
            ],
          ),
        ),
      ),
    );
  }
}
