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
  final heightController = TextEditingController();
  late final Size size;

  @override
  void initState() {
    super.initState();
    heightController.addListener(() => setState(() {}));
    getHeight();
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
                  hintText: heightValue,
                  suffixIcon: heightController.text.isEmpty
                      ? Container(width: 0)
                      : IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () => heightController.clear(),
                        ),
                  prefixIcon: Icon(Icons.height),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: kPrimaryColor, width: 1.5),
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 20.0,
                ),
              ),
              TextField(
                controller: heightController,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  labelText: '身高',
                  hintText: heightValue,
                  suffixIcon: heightController.text.isEmpty
                      ? Container(width: 0)
                      : IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () => heightController.clear(),
                        ),
                  prefixIcon: Icon(Icons.height),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: kPrimaryColor, width: 1.5),
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 20.0,
                ),
              ),
              TextField(
                controller: heightController,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  labelText: '身高',
                  hintText: heightValue,
                  suffixIcon: heightController.text.isEmpty
                      ? Container(width: 0)
                      : IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () => heightController.clear(),
                        ),
                  prefixIcon: Icon(Icons.height),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: kPrimaryColor, width: 1.5),
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 20.0,
                ),
              ),
              TextField(
                controller: heightController,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  labelText: '身高',
                  hintText: heightValue,
                  suffixIcon: heightController.text.isEmpty
                      ? Container(width: 0)
                      : IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () => heightController.clear(),
                        ),
                  prefixIcon: Icon(Icons.height),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: kPrimaryColor, width: 1.5),
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 30.0,
                ),
              ),
              ElevatedButton(
                child: Text('Save'),
                onPressed: () {
                  setHeight(heightController.text);
                  CoolAlert.show(
                    context: context,
                    type: CoolAlertType.success,
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

  Future<void> setHeight(heightValue) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('height', heightValue);
  }

  Future<void> getHeight() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    heightValue = pref.getString('height');
    setState(() {});
  }
}
