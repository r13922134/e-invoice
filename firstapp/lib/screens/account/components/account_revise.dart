import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

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
    showalert() {
      Alert(
        context: context,
        title: '修改成功!',
      ).show();
    }

    return Padding(
      padding: EdgeInsets.all(25),
      child: Center(
        child: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
                  icon: SvgPicture.asset("assets/icons/back_arrow.svg"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 80.0,
                ),
              ),
              TextFormField(
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
                    borderSide: BorderSide(color: kPrimaryColor, width: 0.0),
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 20.0,
                ),
              ),
              TextFormField(
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
                    borderSide: BorderSide(color: kPrimaryColor, width: 0.0),
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
                    borderSide: BorderSide(color: kPrimaryColor, width: 0.0),
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
                    borderSide: BorderSide(color: kPrimaryColor, width: 0.0),
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
                    borderSide: BorderSide(color: kPrimaryColor, width: 0.0),
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
                    borderSide: BorderSide(color: kPrimaryColor, width: 0.0),
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
                    borderSide: BorderSide(color: kPrimaryColor, width: 0.0),
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
                    borderSide: BorderSide(color: kPrimaryColor, width: 0.0),
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
                  showalert();
                },
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _refresh() {
    return Future.delayed(
      Duration(seconds: 0),
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
