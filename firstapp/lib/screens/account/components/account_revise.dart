import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../constants.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:cool_alert/cool_alert.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'dart:convert';

class AccountRevise extends StatefulWidget {
  const AccountRevise({Key? key}) : super(key: key);
  @override
  _ProfileState createState() => _ProfileState();
}

class Disease {
  final int id;
  final String name;

  Disease({
    required this.id,
    required this.name,
  });
}

class _ProfileState extends State<AccountRevise> {
  String? heightValue;
  String? weightValue;
  String? ageValue;

  final heightController = TextEditingController();
  final weightController = TextEditingController();
  final ageController = TextEditingController();

  static List<Disease> _diseases = [
    Disease(id: 1, name: "糖尿病"),
    Disease(id: 2, name: "心血管疾病"),
    Disease(id: 3, name: "腎功能異常"),
  ];
  final _items = _diseases
      .map((diseases) => MultiSelectItem<Disease>(diseases, diseases.name))
      .toList();
  List<Disease> _selectedDisease = [];
  final _multiSelectKey = GlobalKey<FormFieldState>();

  @override
  void initState() {
    super.initState();
    _selectedDisease = _diseases;
    heightController.addListener(() => setState(() {}));
    weightController.addListener(() => setState(() {}));
    ageController.addListener(() => setState(() {}));
    getProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(25),
      child: Center(
        child: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: heightController,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  labelText: '身高',
                  labelStyle: TextStyle(color: kPrimaryColor),
                  hintText: heightValue,
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: kPrimaryColor, width: 2.0),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: kSecondaryColor, width: 2.0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  suffixIcon: heightController.text.isEmpty
                      ? Container(width: 0)
                      : IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () => heightController.clear(),
                        ),
                  prefixIcon: Icon(
                    Icons.boy,
                    color: kPrimaryColor,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 20.0,
                ),
              ),
              TextField(
                controller: weightController,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  labelText: '體重',
                  labelStyle: TextStyle(color: kPrimaryColor),
                  hintText: weightValue,
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: kPrimaryColor, width: 2.0),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: kSecondaryColor, width: 2.0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  suffixIcon: weightController.text.isEmpty
                      ? Container(width: 0)
                      : IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () => weightController.clear(),
                        ),
                  prefixIcon: Icon(
                    Icons.accessibility,
                    color: kPrimaryColor,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 20.0,
                ),
              ),
              TextField(
                controller: ageController,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  labelText: '年齡',
                  labelStyle: TextStyle(color: kPrimaryColor),
                  hintText: ageValue,
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: kPrimaryColor, width: 2.0),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: kSecondaryColor, width: 2.0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  suffixIcon: ageController.text.isEmpty
                      ? Container(width: 0)
                      : IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () => ageController.clear(),
                        ),
                  prefixIcon: Icon(
                    Icons.edit,
                    color: kPrimaryColor,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 20.0,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: kBackgroundColor,
                  border: Border.all(
                    color: kSecondaryColor,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(10),
                  shape: BoxShape.rectangle,
                ),
                child: Column(
                  children: <Widget>[
                    MultiSelectBottomSheetField(
                      initialChildSize: 0.4,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          shape: BoxShape.rectangle,
                          color: kBackgroundColor,
                          border: Border.all(color: kSecondaryColor, width: 1)),
                      listType: MultiSelectListType.CHIP,
                      searchable: true,
                      buttonText: Text(
                        "疾病史",
                        style: TextStyle(color: kPrimaryColor),
                      ),
                      buttonIcon:
                          Icon(Icons.arrow_drop_down, color: kPrimaryColor),
                      title: Text("選擇"),
                      items: _items,
                      onConfirm: (values) {
                        _selectedDisease = values as List<Disease>;
                      },
                      chipDisplay: MultiSelectChipDisplay<Disease>(
                        chipColor: kSecondaryColor,
                        icon: Icon(Icons.cancel_sharp, color: kTextColor),
                        textStyle: TextStyle(
                          color: kTextColor,
                        ),
                        onTap: (value) {
                          setState(() {
                            _selectedDisease.remove(value);
                          });
                        },
                      ),
                    ),
                    _selectedDisease == null || _selectedDisease.isEmpty
                        ? Container(
                            padding: EdgeInsets.all(10),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "None selected",
                              style: TextStyle(color: Colors.black54),
                            ))
                        : Container(),
                  ],
                ),
              ),
              SizedBox(height: 40),
              ElevatedButton(
                child: Text('儲存'),
                style: ElevatedButton.styleFrom(
                    shape: StadiumBorder(),
                    primary: kPrimaryColor,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                    textStyle:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                onPressed: () {
                  setProfile(heightController.text, weightController.text,
                      ageController.text);
                  CoolAlert.show(
                    context: context,
                    type: CoolAlertType.success,
                    confirmBtnColor: kPrimaryColor,
                    text: "修改成功!",
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> setProfile(heightValue, weightValue, ageValue) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('height', heightValue);
    pref.setString('weight', weightValue);
    pref.setString('age', ageValue);
  }

  Future<void> getProfile() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    heightValue = pref.getString('height');
    weightValue = pref.getString('weight');
    ageValue = pref.getString('age');
    setState(() {});
  }
}
