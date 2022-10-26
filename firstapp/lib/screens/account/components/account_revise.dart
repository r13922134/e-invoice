import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../constants.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:cool_alert/cool_alert.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'dart:convert';
import 'package:selectable_list/selectable_list.dart';
import 'package:firstapp/screens/analysis/calculate.dart';

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

class Activity {
  final String strength;
  final String illustrate;

  Activity(this.strength, this.illustrate);
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
    Disease(id: 1, name: "低醣飲食"),
    Disease(id: 2, name: "高血壓飲食"),
    Disease(id: 3, name: "減脂飲食"),
    Disease(id: 4, name: "低鈉飲食"),
    Disease(id: 5, name: "居家運動"),
    Disease(id: 6, name: "減肥"),
    Disease(id: 7, name: "飲食新知"),
    Disease(id: 7, name: "過敏飲食"),
  ];
  String? activityValue;
  final Activitys = [
    //Activity("Little to no exercise", "大部份時間都在坐著唸書·做功課·談話，有部份時間會看電視或欣賞音樂，并有約一小時散步、購物等身體活動程度為正常速度·熱量消耗較少的活動"),
    Activity("Light exercise",
        "大部份時間都坐著工作或談話，有部份時間會站著，例如乘車、接待客人、做家事等。另外會有約二小時的時間因工作或通勤的原故，需要步行"),
    Activity("Moderate exercise",
        "日常活動強度與稍低者大致相同，但每日多從事1小時活動速度快。熱量消耗較多的活動，如快走或騎腳踏車等。或者大部份是處於站著工作，而且從事約1小時活動輕度較強的工作，如農漁業"),
    Activity("Heavy exercise",
        "從事重物搬運、農漁業等站立姿勢且活動強度較強的工作。或每日有1小時的運動訓練、激烈的肌肉運動，如游泳、登山、打網球等活動程度較快或激烈且熱量消耗多的運動")
  ];

  final _items = _diseases
      .map((diseases) => MultiSelectItem<Disease>(diseases, diseases.name))
      .toList();

  Future<void> setProfile(
      heightValue, weightValue, ageValue, genderValue) async {
    String tmpgender;
    String tmpact;
    SharedPreferences pref = await SharedPreferences.getInstance();
    final String encodedData = Disease.encode(_selectedDisease);
    pref.setString('select_diseases', encodedData);
    if (genderValue == 0) {
      tmpgender = '男';
      pref.setString('gender', "男");
    } else {
      tmpgender = '女';
      pref.setString('gender', "女");
    }
    pref.setInt('height', heightValue);
    pref.setInt('weight', weightValue);
    pref.setInt('age', ageValue);
    if (activityValue == '') {
      tmpact = 'Light exercise';
      pref.setString('activity', "Light exercise");
    } else if (activityValue == "Light exercise") {
      tmpact = 'Light exercise';

      pref.setString('activity', "Light exercise");
    } else if (activityValue == "Moderate exercise") {
      tmpact = 'Moderate exercise';

      pref.setString('activity', "Moderate exercise");
    } else {
      tmpact = 'Heavy exercise';

      pref.setString('activity', "Heavy exercise");
    }
    Calculate c = Calculate(
        height: heightValue,
        weight: weightValue,
        gender: tmpgender,
        activity: tmpact);
    c.calculateBMI();
    String bmirange = c.getInterpretation();
    if (ageValue > 18) {
      pref.setInt('mixCalorie', c.getdailyCalorie());
    } else if (ageValue > 15) {
      pref.setInt('mixCalorie', c.getdailyCalorie_teenager());
    } else if (ageValue >= 13) {
      pref.setInt('mixCalorie', c.getdailyCalorie_child());
    } else {
      pref.setInt('mixCalorie', 1200);
    }
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
                          backgroundColor:
                              const Color.fromARGB(255, 36, 145, 126),
                          unselectedBackgroundColor: Colors.white,
                          unselectedLabelStyle: const TextStyle(
                              color: kSecondaryColor,
                              fontWeight: FontWeight.bold),
                          borderWidth: 2,
                          contentPadding: const EdgeInsets.all(10),
                          radius: 15,
                          height: 55,
                          tabs: const [
                            Tab(icon: Icon(Icons.male)),
                            Tab(icon: Icon(Icons.female))
                          ],
                          onTap: (index) {
                            genderValue = index;
                          }),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(children: [
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
                        itemHeight: 50,
                        onChanged: (value) => setState(() => ageValue = value),
                      ),
                    ]),
                    Column(children: [
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
                        itemHeight: 50,
                        onChanged: (value) =>
                            setState(() => heightValue = value),
                      ),
                    ]),
                    Column(
                      children: [
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
                          itemHeight: 50,
                          onChanged: (value) =>
                              setState(() => weightValue = value),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const <Widget>[
                      Icon(Icons.assessment_outlined),
                      Text(
                        "日常活動強度",
                        style: TextStyle(
                          color: Color.fromARGB(255, 80, 80, 80),
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ]),
                Padding(
                  padding: EdgeInsets.all(18),
                  child: SelectableList<Activity, String?>(
                    items: Activitys,
                    itemBuilder: (context, Activity, selected, onTap) =>
                        ListTile(
                            title: Text(Activity.strength),
                            subtitle: Text(Activity.illustrate.toString()),
                            selected: selected,
                            onTap: onTap),
                    valueSelector: (Activity) => Activity.strength,
                    selectedValue: activityValue,
                    onItemSelected: (Activity) =>
                        setState(() => activityValue = Activity.strength),
                    onItemDeselected: (Activity) =>
                        setState(() => activityValue = null),
                  ),
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
                      MultiSelectBottomSheetField<Disease>(
                        initialValue: _selectedDisease,
                        selectedItemsTextStyle:
                            const TextStyle(color: Colors.white),
                        selectedColor: kPrimaryColor,
                        initialChildSize: 0.4,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            shape: BoxShape.rectangle,
                            color: kBackgroundColor,
                            border:
                                Border.all(color: kSecondaryColor, width: 1)),
                        listType: MultiSelectListType.CHIP,
                        searchable: true,
                        unselectedColor:
                            const Color.fromARGB(255, 179, 178, 178),
                        buttonText: const Text(
                          "感興趣的議題",
                          style: TextStyle(
                            color: Color.fromARGB(255, 80, 80, 80),
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        buttonIcon: const Icon(Icons.arrow_drop_down,
                            color: kPrimaryColor),
                        title: const Text("選擇"),
                        items: _items,
                        onConfirm: (values) {
                          _selectedDisease = values as List<Disease>;
                        },
                        chipDisplay: MultiSelectChipDisplay<Disease>(
                          chipColor: kSecondaryColor,
                          icon:
                              const Icon(Icons.cancel_sharp, color: kTextColor),
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 20),
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
            )));
  }

  AppBar buildAppBar(context) {
    return AppBar(
      backgroundColor: kPrimaryColor,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_sharp,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
