import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../constants.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:cool_alert/cool_alert.dart';

class AccountRevise extends StatefulWidget {
  const AccountRevise({Key? key}) : super(key: key);
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<AccountRevise> {
  String? heightValue;
  String? weightValue;
  String? ageValue;

  final heightController = TextEditingController();
  final weightController = TextEditingController();
  final ageController = TextEditingController();

  @override
  void initState() {
    super.initState();
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
              ElevatedButton(
                child: Text('Save'),
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
