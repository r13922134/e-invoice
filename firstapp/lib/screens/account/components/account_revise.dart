import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../constants.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:cool_alert/cool_alert.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'dart:convert';
import 'package:flutter_svg/svg.dart';

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
  factory Disease.fromJson(Map<String, dynamic> jsonData) {
    return Disease(
      id: jsonData['id'],
      name: jsonData['name'],
    );
  }

  static Map<String, dynamic> toMap(Disease disease) => {
        'id': disease.id,
        'name': disease.name,
      };

  static String encode(List<Disease> diseases) => json.encode(
        diseases
            .map<Map<String, dynamic>>((disease) => Disease.toMap(disease))
            .toList(),
      );

  static List<Disease> decode(String diseases) =>
      (json.decode(diseases) as List<dynamic>)
          .map<Disease>((item) => Disease.fromJson(item))
          .toList();
}

class _ProfileState extends State<AccountRevise> {
  int heightValue = 120;
  int weightValue = 30;
  int ageValue = 1;
  List<Disease> _selectedDisease = [];
  int genderValue = 0;
  String? listString;
  int height = 120, weight = 30, age = 1, gender = 0;
  static final List<Disease> _diseases = [
    Disease(id: 1, name: "糖尿病"),
    Disease(id: 2, name: "高血壓"),
    Disease(id: 3, name: "高血脂"),
    Disease(id: 4, name: "腎功能異常"),
  ];

  final _items = _diseases
      .map((diseases) => MultiSelectItem<Disease>(diseases, diseases.name))
      .toList();

  Future<void> setProfile(
      heightValue, weightValue, ageValue, genderValue) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final String encodedData = Disease.encode(_selectedDisease);
    pref.setString('select_diseases', encodedData);
    if (genderValue == 0) {
      pref.setString('gender', "男");
    } else {
      pref.setString('gender', "女");
    }
    pref.setInt('height', heightValue);
    pref.setInt('weight', weightValue);
    pref.setInt('age', ageValue);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: ListView(
          children: <Widget>[
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  Icon(Icons.supervisor_account_outlined),
                  Text(
                    "性別",
                    style: TextStyle(
                      color: Color.fromARGB(255, 80, 80, 80),
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ]),
            const SizedBox(height: 10),
            DefaultTabController(
              initialIndex: genderValue,
              length: 2,
              child: Column(
                children: <Widget>[
                  ButtonsTabBar(
                      borderColor: const Color.fromARGB(255, 36, 145, 126),
                      unselectedBorderColor: kSecondaryColor,
                      backgroundColor: const Color.fromARGB(255, 36, 145, 126),
                      unselectedBackgroundColor: Colors.white,
                      unselectedLabelStyle: const TextStyle(
                          color: kSecondaryColor, fontWeight: FontWeight.bold),
                      borderWidth: 2,
                      contentPadding: const EdgeInsets.all(10),
                      radius: 15,
                      height: 55,
                      tabs: [
                        const Tab(icon: Icon(Icons.male)),
                        const Tab(icon: Icon(Icons.female))
                      ],
                      onTap: (index) {
                        genderValue = index;
                      }),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  Icon(Icons.edit),
                  Text(
                    "年齡",
                    style: TextStyle(
                      color: Color.fromARGB(255, 80, 80, 80),
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ]),
            NumberPicker(
              textStyle: const TextStyle(color: kPrimaryColor),
              selectedTextStyle: const TextStyle(
                color: Color.fromARGB(255, 36, 145, 126),
                fontSize: 35,
                fontWeight: FontWeight.w700,
              ),
              value: ageValue,
              minValue: 1,
              maxValue: 100,
              step: 1,
              itemHeight: 38,
              onChanged: (value) => setState(() => ageValue = value),
            ),
            const SizedBox(height: 10),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  Icon(Icons.boy),
                  Text(
                    "身高(cm)",
                    style: TextStyle(
                      color: Color.fromARGB(255, 80, 80, 80),
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ]),
            NumberPicker(
              textStyle: const TextStyle(color: kPrimaryColor),
              selectedTextStyle: const TextStyle(
                color: Color.fromARGB(255, 36, 145, 126),
                fontSize: 35,
                fontWeight: FontWeight.w700,
              ),
              value: heightValue,
              minValue: 120,
              maxValue: 220,
              step: 1,
              itemHeight: 38,
              onChanged: (value) => setState(() => heightValue = value),
            ),
            const SizedBox(height: 10),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  Icon(Icons.accessibility),
                  Text(
                    "體重(kg)",
                    style: TextStyle(
                      color: Color.fromARGB(255, 80, 80, 80),
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ]),
            NumberPicker(
              textStyle: const TextStyle(color: kPrimaryColor),
              selectedTextStyle: const TextStyle(
                color: Color.fromARGB(255, 36, 145, 126),
                fontSize: 35,
                fontWeight: FontWeight.w700,
              ),
              value: weightValue,
              minValue: 30,
              maxValue: 150,
              step: 1,
              itemHeight: 38,
              onChanged: (value) => setState(() => weightValue = value),
            ),
            const SizedBox(height: 8),
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
                    initialValue: _selectedDisease,
                    selectedItemsTextStyle:
                        const TextStyle(color: Colors.white),
                    selectedColor: kPrimaryColor,
                    initialChildSize: 0.4,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        shape: BoxShape.rectangle,
                        color: kBackgroundColor,
                        border: Border.all(color: kSecondaryColor, width: 1)),
                    listType: MultiSelectListType.CHIP,
                    searchable: true,
                    unselectedColor: const Color.fromARGB(255, 179, 178, 178),
                    buttonText: const Text(
                      "疾病史",
                      style: TextStyle(
                        color: Color.fromARGB(255, 80, 80, 80),
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    buttonIcon:
                        const Icon(Icons.arrow_drop_down, color: kPrimaryColor),
                    title: const Text("選擇"),
                    items: _items,
                    onConfirm: (values) {
                      _selectedDisease = values as List<Disease>;
                    },
                    chipDisplay: MultiSelectChipDisplay<Disease>(
                      chipColor: kSecondaryColor,
                      icon: const Icon(Icons.cancel_sharp, color: kTextColor),
                      textStyle: const TextStyle(
                        color: kTextColor,
                      ),
                      onTap: (value) {
                        _selectedDisease.remove(value);
                        return _selectedDisease;
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text('儲存'),
              style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                  primary: kPrimaryColor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  textStyle: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold)),
              onPressed: () {
                setProfile(heightValue, weightValue, ageValue, genderValue);
                CoolAlert.show(
                  context: context,
                  type: CoolAlertType.success,
                  confirmBtnColor: kPrimaryColor,
                  onConfirmBtnTap: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  text: "修改成功!",
                );
              },
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar(context) {
    return AppBar(
      backgroundColor: kPrimaryColor,
      elevation: 0,
      leading: IconButton(
        icon: SvgPicture.asset("assets/icons/back_arrow.svg"),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
