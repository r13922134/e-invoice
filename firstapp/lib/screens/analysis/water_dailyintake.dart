import 'dart:async';
import 'package:firstapp/constants.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WaterIntake extends StatefulWidget {
  const WaterIntake({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _WaterIntake();
}

class _WaterIntake extends State<WaterIntake> {
  //TextEditingController watercontroller = TextEditingController();
  double _ml = 0;
  double _total = 0;
  //double _percent = 0;
  //test
  //final String drinkcounter = "drinkcounter";
  double mls = 0; //saved data
  String datestamp = ''; //save date
  String temp = "初始"; //now date

  final _textFieldController = new TextEditingController();
  var _storageString = '';
  var _storageDate = '';
  final STORAGE_KEY = 'storage_key';
  final DATE_KEY = 'date_key';

  //int timestamp = DateTime.now().millisecondsSinceEpoch;

  static final DateTime now = DateTime.now();
  //static final DateFormat formatter = DateFormat('yyyy-MM-dd');
  //final String formatted = formatter.format(now);

  DateTime date = DateTime(now.year, now.month, now.day);
  DateTime Testnow = DateTime.now();
  DateTime reset = DateTime(now.year, now.month, now.day);

  //int sec = 0;
  //late Timer timer;

  //Timer? _timer;
  //int currentTime = 0;

  /*void initTimer() {
    if (_timer != null && _timer!.isActive) return;

    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      //job
      setState(() {});
    });
  }*/

  @override
  void initState() {
    _textFieldController.text = ''; //innitail value of text field
    super.initState();
    setTotal();
  }

  Future saveString() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(STORAGE_KEY, mls.toString());
    sharedPreferences.setString(DATE_KEY, datestamp);
    _textFieldController.text = "";
  }

  /**
   * 獲取存在SharedPreferences中的資料
   */
  Future getString() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      _storageString = sharedPreferences.get(STORAGE_KEY) as String;
      _storageDate = sharedPreferences.get(DATE_KEY) as String;
      mls = double.parse(_storageString);
    });
  }

  Future setTotal() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      _storageString = sharedPreferences.get(STORAGE_KEY) as String;
      _storageDate = sharedPreferences.get(DATE_KEY) as String;
      //_total = double.parse(_storageString);
      if (_storageDate != (DateTime(now.year, now.month, now.day)).toString()) {
        _total = 0;
      } else {
        _total = double.parse(_storageString);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //initTimer();
    return Neumorphic(
        style: NeumorphicStyle(
            shape: NeumorphicShape.concave,
            intensity: 0.9,
            boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(25)),
            depth: 10,
            lightSource: LightSource.topRight,
            color: const Color.fromARGB(255, 207, 219, 235)),
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            //mainAxisAlignment: MainAxisAlignment.start,
            //mainAxisSize: MainAxisSize.max,
            children: [
              Row(children: const [
                Icon(
                  Icons.water_drop_rounded,
                  color: kBackgroundColor,
                ),
                Text(
                  ' 飲水量紀錄',
                  style: TextStyle(
                      color: Color.fromARGB(255, 87, 96, 120),
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
              ]),

              Container(height: 15),
              CircularPercentIndicator(
                radius: 100.0,
                lineWidth: 40.0,
                animation: true,
                backgroundColor: const Color.fromARGB(255, 230, 239, 247),
                percent: (_total / 2000),
                center: Text(
                  ((((_total / 2000) * 100).toStringAsFixed(2))).toString() +
                      "%",
                  style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600,
                      color: Color.fromARGB(255, 87, 104, 120)),
                ),
                circularStrokeCap: CircularStrokeCap.round,
                progressColor: const Color.fromARGB(255, 43, 161, 92),
              ),

              //Text("shared_preferences儲存", textAlign: TextAlign.center),
              Padding(
                padding: const EdgeInsets.all(30),
                child: TextField(
                    controller: _textFieldController,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        labelText: "飲水量 (ml)",
                        labelStyle: const TextStyle(
                            color: Color.fromARGB(255, 140, 152, 189)),
                        prefixIcon: const Icon(Icons.local_drink,
                            color: Color.fromARGB(255, 140, 152, 189)),
                        border: myinputborder(),
                        enabledBorder: myinputborder(),
                        focusedBorder: myfocusborder(),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.check_circle),
                          color: const Color.fromARGB(255, 140, 152, 189),
                          onPressed: () {
                            _ml = double.parse(_textFieldController.text);
                            Testnow = DateTime.now();
                            reset = DateTime(
                                Testnow.year, Testnow.month, Testnow.day);
                            temp = reset.toString();
                            if (_storageDate != temp.toString()) {
                              _total = 0;
                              if (_total + _ml > 2000) {
                                _total = 2000;
                                mls = 2000;
                                _textFieldController.text = "";
                              } else if (_total + _ml <= 2000) {
                                _total = _total + _ml;
                                mls = _total;
                                _textFieldController.text = "";
                              }
                              saveString();
                              getString();
                            } else {
                              if (_total + _ml > 2000) {
                                _total = 2000;
                                mls = 2000;
                                _textFieldController.text = "";
                              } else if (_total + _ml <= 2000) {
                                _total = _total + _ml;
                                mls = _total;
                                _textFieldController.text = "";
                              }
                              debugPrint('一樣 $temp');
                              saveString();
                              getString();
                            }
                            DateTime now = DateTime.now();
                            datestamp = (DateTime(now.year, now.month, now.day))
                                .toString();
                            saveString();
                            getString();
                          },
                        ))),
              ),
              /*MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22.0)),
              minWidth: 10.0,
              onPressed: () {
                _total = 0;
                mls = 0;
                saveString();
                getString();
              },
              child: new Text("歸零"),
              color: Color.fromARGB(255, 255, 238, 181),
            ),*/
              /*
              Text('shared_preferences儲存的值為  $_storageString'),
              Text(' $mls'),*/
              /*Text('紀錄喝水時間 $datestamp'),
            Text('上次儲存時間 $_storageDate'),
            Text('開啟app時間 ' +
                (DateTime(now.year, now.month, now.day)).toString()),
            Text('$now'),
            Text('$temp'),
            Text('$_total'),*/
              /*RawMaterialButton(
              onPressed: () {
                if (_storageDate !=
                    (new DateTime(now.year, now.month, now.day)).toString()) {
                  _total = 0;
                } else {
                  _total = double.parse(_storageString);
                }
              },
              //elevation: 1.0,
              fillColor: Colors.white,
              child: Icon(
                Icons.restart_alt,
                size: 10.0,
              ),
              //padding: EdgeInsets.all(1.0),
              shape: CircleBorder(),
            )*/
              /*ElevatedButton(
                onPressed: () {
                  showAlertDialog(context);
                  _total = 0;
                  mls = 0;
                  saveString();
                  getString();
                },
                style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    primary: Color.fromARGB(255, 109, 158, 214),
                    fixedSize: const Size(10, 10)),
                child: const Icon(Icons.delete)),*/
              ElevatedButton(
                  onPressed: () {
                    Testnow = DateTime.now();
                    reset = DateTime(Testnow.year, Testnow.month, Testnow.day);
                    temp = reset.toString();
                    if (_storageDate != temp.toString()) {
                      _total = 0;
                      //debugPrint('一樣 $_storageDate 和 $temp');
                      //debugPrint('$_storageDate');
                      //debugPrint('不一樣 $Testnow');
                      saveString();
                      getString();
                    } else {
                      _total = double.parse(_storageString);
                      //debugPrint('不一樣 $_storageDate 和 $temp');
                      //debugPrint('$_storageDate');
                      //debugPrint('一樣 $temp');
                      saveString();
                      getString();
                    }
                    //debugPrint('$_storageDate');
                  },
                  style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      primary: Colors.blueGrey,
                      fixedSize: const Size(10, 10)),
                  child: const Icon(Icons.restart_alt)),
            ],
          ),
        ));
  }

  showAlertDialog(BuildContext context) {
    // Init
    AlertDialog dialog = AlertDialog(
      title: const Text("AlertDialog component"),
      actions: [
        ElevatedButton(
            child: const Text("OK"),
            onPressed: () {
              Navigator.pop(context);
            }),
        ElevatedButton(
            child: const Text("Cancel"),
            onPressed: () {
              Navigator.pop(context);
            }),
      ],
    );

    // Show the dialog
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return dialog;
        });
  }

  OutlineInputBorder myinputborder() {
    //return type is OutlineInputBorder
    return const OutlineInputBorder(
        //Outline border type for TextFeild
        borderRadius: BorderRadius.all(Radius.circular(20)),
        borderSide: BorderSide(
          color: Color.fromARGB(255, 140, 152, 189),
          width: 2,
        ));
  }

  OutlineInputBorder myfocusborder() {
    return const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        borderSide: BorderSide(
          color: Color.fromARGB(255, 140, 152, 189),
          width: 2,
        ));
  }
}
