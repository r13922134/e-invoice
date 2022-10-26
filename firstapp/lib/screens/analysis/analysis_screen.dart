// ignore_for_file: prefer_const_constructors, unnecessary_new

import 'package:firstapp/constants.dart';
import 'package:firstapp/screens/analysis/water_dailyintake.dart';
import 'package:flutter/cupertino.dart';
import 'package:firstapp/screens/analysis/analysis_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:firstapp/screens/analysis/card_info.dart';
import 'package:firstapp/screens/analysis/card_detail.dart';
import 'package:firstapp/screens/analysis/consumption.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flip_card/flip_card.dart';
import 'package:firstapp/screens/account/components/account_revise.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

DateTime now = DateTime.now();
DateTime date = DateTime(now.year, now.month, now.day);
List<String> splitted = date.toString().split('-');
String tmpdate =
    splitted[0] + '/' + splitted[1] + '/' + splitted[2][0] + splitted[2][1];
String _date = tmpdate;

class AnalysisScreen extends StatefulWidget {
  const AnalysisScreen({Key? key}) : super(key: key);
  @override
  _IdentityPageState createState() => _IdentityPageState();
}

class _IdentityPageState extends State<AnalysisScreen> {
  int heightValue = 0, weightValue = 0, ageValue = 0;
  int mixCalorie = -1;

  void getmixcalorie() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      mixCalorie = pref.getInt('mixCalorie') ?? 1200;
      heightValue = pref.getInt('height') ?? 120;
      weightValue = pref.getInt('weight') ?? 30;
      ageValue = pref.getInt('age') ?? 1;
    });
  }

  @override
  void initState() {
    getmixcalorie();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5),
                      SizedBox(
                        width: 134,
                        height: 35,
                        child: DateTimePicker(
                          type: DateTimePickerType.date,
                          dateMask: 'yyyy/MM/dd',
                          initialValue: _date.toString(),
                          style: const TextStyle(
                              fontSize: 10, color: Colors.black),
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  // width: 0.0 produces a thin "hairline" border
                                  borderSide:
                                      const BorderSide(color: kSecondaryColor),
                                  borderRadius: BorderRadius.circular(15)),
                              filled: true,
                              fillColor: kSecondaryColor,
                              suffixIcon: const Icon(Icons.arrow_drop_down,
                                  color: Colors.black),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15))),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                          onChanged: (val) {
                            splitted = val.toString().split('-');
                            tmpdate = splitted[0] +
                                '/' +
                                splitted[1] +
                                '/' +
                                splitted[2];

                            return setState(() => _date = tmpdate);
                          },
                          validator: (val) {
                            setState(() => _date = val ?? '');
                            return null;
                          },
                          onSaved: (val) => setState(() => _date = val ?? ''),
                        ),
                      ),
                      FutureBuilder<List<CardInfo>>(
                          future: getcurrentdate(_date),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              if (snapshot.data?.isEmpty ?? true) {
                                return SizedBox(
                                    height: 260,
                                    child: Center(
                                        child: Column(children: [
                                      const SizedBox(height: 50),
                                      Image.asset('assets/images/cancel.png',
                                          width: 150),
                                      const Text("此日期無食物紀錄",
                                          style: TextStyle(
                                            color: kPrimaryColor,
                                            fontFamily: 'Avenir',
                                            fontSize: 19,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          textAlign: TextAlign.center)
                                    ])));
                              } else {
                                int len = snapshot.data.length - 1;
                                int sum = snapshot.data[0].total ?? 0;

                                return Column(children: [
                                  Swiper(
                                    index: len,
                                    onTap: (index) {
                                      Navigator.push(
                                        context,
                                        PageRouteBuilder(
                                          pageBuilder: (context, a, b) =>
                                              DetailPage(
                                            cardInfo:
                                                snapshot.data[len - index],
                                            index: index,
                                          ),
                                        ),
                                      );
                                    },
                                    itemCount: snapshot.data.length,
                                    itemWidth:
                                        MediaQuery.of(context).size.width -
                                            2 * 34,
                                    itemHeight: 280.0,
                                    layout: SwiperLayout.TINDER,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return InkWell(
                                        child: Stack(
                                          alignment:
                                              AlignmentDirectional.topCenter,
                                          children: <Widget>[
                                            Column(
                                              children: <Widget>[
                                                const SizedBox(height: 50),
                                                Card(
                                                  elevation: 8,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            32),
                                                  ),
                                                  color: Colors.white,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            32.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: <Widget>[
                                                        const SizedBox(
                                                            height: 33),
                                                        snapshot
                                                                    .data[len -
                                                                        index]
                                                                    .name
                                                                    .length <
                                                                14
                                                            ? Text(
                                                                snapshot
                                                                    .data[len -
                                                                        index]
                                                                    .name,
                                                                style:
                                                                    const TextStyle(
                                                                  fontFamily:
                                                                      'Avenir',
                                                                  fontSize: 19,
                                                                  color:
                                                                      kTextColor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                              )
                                                            : Text(
                                                                snapshot
                                                                        .data[len -
                                                                            index]
                                                                        .name
                                                                        .substring(
                                                                            0,
                                                                            12) +
                                                                    "..",
                                                                style:
                                                                    const TextStyle(
                                                                  fontFamily:
                                                                      'Avenir',
                                                                  fontSize: 19,
                                                                  color:
                                                                      kTextColor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                              ),
                                                        const SizedBox(
                                                            height: 15),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              snapshot
                                                                  .data[len -
                                                                      index]
                                                                  .calorie,
                                                              style:
                                                                  const TextStyle(
                                                                fontFamily:
                                                                    'Avenir',
                                                                fontSize: 30,
                                                                color:
                                                                    kPrimaryColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w900,
                                                              ),
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                            ),
                                                            Text(
                                                              ' kcal  ',
                                                              style:
                                                                  const TextStyle(
                                                                fontFamily:
                                                                    'Avenir',
                                                                fontSize: 20,
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        175,
                                                                        175,
                                                                        175),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                            ),
                                                            Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(6),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        247,
                                                                        252,
                                                                        255),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            15),
                                                              ),
                                                              child: Text(
                                                                " x" +
                                                                    snapshot
                                                                        .data[len -
                                                                            index]
                                                                        .quantity +
                                                                    ' ',
                                                                style:
                                                                    const TextStyle(
                                                                  fontFamily:
                                                                      'Avenir',
                                                                  fontSize: 12,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          199,
                                                                          199,
                                                                          199),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w900,
                                                                ),
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                            height: 10),
                                                        Row(
                                                          children: const <
                                                              Widget>[
                                                            Text(
                                                              '更多資訊',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Avenir',
                                                                fontSize: 18,
                                                                color:
                                                                    kTextColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                            ),
                                                            Icon(
                                                              Icons
                                                                  .arrow_forward,
                                                              color: kTextColor,
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Hero(
                                              tag: index,
                                              child: Image.asset(
                                                  snapshot.data[len - index]
                                                          .images ??
                                                      '',
                                                  width: 120),
                                            ),
                                            Positioned(
                                              right: 24,
                                              bottom: 1,
                                              child: Text(
                                                snapshot
                                                    .data[len - index].position
                                                    .toString(),
                                                style: TextStyle(
                                                  fontFamily: 'Avenir',
                                                  fontSize: 120,
                                                  color: kTextColor
                                                      .withOpacity(0.08),
                                                  fontWeight: FontWeight.w900,
                                                ),
                                                textAlign: TextAlign.left,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                  SizedBox(height: 20),
                                  FlipCard(
                                      fill: Fill
                                          .fillBack, // Fill the back side of the card to make in the same size as the front.
                                      direction:
                                          FlipDirection.VERTICAL, // default
                                      front: Neumorphic(
                                        style: NeumorphicStyle(
                                            shape: NeumorphicShape.concave,
                                            intensity: 0.9,
                                            boxShape:
                                                NeumorphicBoxShape.roundRect(
                                                    BorderRadius.circular(25)),
                                            depth: 10,
                                            lightSource: LightSource.topRight,
                                            color: const Color.fromARGB(
                                                255, 110, 136, 148)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(20),
                                          child: Row(
                                            children: [
                                              Flexible(
                                                child: SizedBox(
                                                  width: (size.width),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      const Text(
                                                        "單日熱量加總(kcal)",
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      Row(
                                                        children: [
                                                          Icon(Icons.date_range,
                                                              size: 15,
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      219,
                                                                      227,
                                                                      231)),
                                                          Text(
                                                            "日期:  " + _date,
                                                            style: const TextStyle(
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        219,
                                                                        227,
                                                                        231)),
                                                          ),
                                                        ],
                                                      ),
                                                      Icon(
                                                        Icons
                                                            .rotate_left_rounded,
                                                        color: Colors.white,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 20,
                                              ),
                                              Neumorphic(
                                                padding: EdgeInsets.all(31),
                                                style: NeumorphicStyle(
                                                    intensity: 0.9,
                                                    surfaceIntensity: 0.9,
                                                    boxShape: NeumorphicBoxShape
                                                        .circle(),
                                                    depth: -5,
                                                    lightSource:
                                                        LightSource.topRight,
                                                    color: Color.fromARGB(
                                                        255, 238, 238, 238)),
                                                child: Center(
                                                  child: Text(
                                                    sum.toString(),
                                                    style: TextStyle(
                                                        fontSize: 22,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Color.fromARGB(
                                                            255, 57, 161, 31)),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      back: Neumorphic(
                                        style: NeumorphicStyle(
                                            shape: NeumorphicShape.concave,
                                            intensity: 0.5,
                                            boxShape:
                                                NeumorphicBoxShape.roundRect(
                                                    BorderRadius.circular(25)),
                                            depth: 10,
                                            lightSource: LightSource.topRight,
                                            color: sum <= mixCalorie
                                                ? Color.fromARGB(
                                                    255, 206, 223, 217)
                                                : Color.fromARGB(
                                                    255, 243, 120, 112)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(20),
                                          child: Row(
                                            children: [
                                              Flexible(
                                                child: SizedBox(
                                                  width: (size.width),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(
                                                            "每日建議攝取量(kcal)  ",
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: sum <=
                                                                        mixCalorie
                                                                    ? Color
                                                                        .fromARGB(
                                                                            255,
                                                                            108,
                                                                            141,
                                                                            133)
                                                                    : Colors
                                                                        .white),
                                                          ),
                                                          if (sum > mixCalorie)
                                                            Row(
                                                              children: const [
                                                                Icon(
                                                                    Icons
                                                                        .warning,
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            240,
                                                                            184,
                                                                            29),
                                                                    size: 15),
                                                                Text(
                                                                  "超出上限",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          10,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              ],
                                                            )
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Icon(
                                                              CupertinoIcons
                                                                  .tag_solid,
                                                              size: 15,
                                                              color: sum <=
                                                                      mixCalorie
                                                                  ? Colors
                                                                      .blueGrey
                                                                  : Color
                                                                      .fromARGB(
                                                                          255,
                                                                          221,
                                                                          186,
                                                                          30)),
                                                          Text(
                                                            "年齡:",
                                                            style: TextStyle(
                                                                fontSize: 11,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: sum <=
                                                                        mixCalorie
                                                                    ? Color
                                                                        .fromARGB(
                                                                            255,
                                                                            108,
                                                                            141,
                                                                            133)
                                                                    : Colors
                                                                        .white),
                                                          ),
                                                          Text(
                                                            ageValue.toString() +
                                                                ' ',
                                                            style: TextStyle(
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: sum <=
                                                                        mixCalorie
                                                                    ? Color
                                                                        .fromARGB(
                                                                            255,
                                                                            4,
                                                                            71,
                                                                            7)
                                                                    : Color
                                                                        .fromARGB(
                                                                            255,
                                                                            240,
                                                                            184,
                                                                            29)),
                                                          ),
                                                          Icon(Icons.boy,
                                                              color: sum <=
                                                                      mixCalorie
                                                                  ? Colors
                                                                      .blueGrey
                                                                  : Color
                                                                      .fromARGB(
                                                                          255,
                                                                          221,
                                                                          186,
                                                                          30)),
                                                          Text(
                                                            "身高:",
                                                            style: TextStyle(
                                                                fontSize: 11,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: sum <=
                                                                        mixCalorie
                                                                    ? Color
                                                                        .fromARGB(
                                                                            255,
                                                                            108,
                                                                            141,
                                                                            133)
                                                                    : Colors
                                                                        .white),
                                                          ),
                                                          Text(
                                                            heightValue
                                                                    .toString() +
                                                                ' ',
                                                            style: TextStyle(
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: sum <=
                                                                        mixCalorie
                                                                    ? Color
                                                                        .fromARGB(
                                                                            255,
                                                                            4,
                                                                            71,
                                                                            7)
                                                                    : Color
                                                                        .fromARGB(
                                                                            255,
                                                                            240,
                                                                            184,
                                                                            29)),
                                                          ),
                                                          Icon(
                                                              Icons
                                                                  .accessibility,
                                                              color: sum <=
                                                                      mixCalorie
                                                                  ? Colors
                                                                      .blueGrey
                                                                  : Color
                                                                      .fromARGB(
                                                                          255,
                                                                          221,
                                                                          186,
                                                                          30)),
                                                          Text(
                                                            "體重:",
                                                            style: TextStyle(
                                                                fontSize: 11,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: sum <=
                                                                        mixCalorie
                                                                    ? Color
                                                                        .fromARGB(
                                                                            255,
                                                                            108,
                                                                            141,
                                                                            133)
                                                                    : Colors
                                                                        .white),
                                                          ),
                                                          Text(
                                                            weightValue
                                                                    .toString() +
                                                                ' ',
                                                            style: TextStyle(
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: sum <=
                                                                        mixCalorie
                                                                    ? Color
                                                                        .fromARGB(
                                                                            255,
                                                                            4,
                                                                            71,
                                                                            7)
                                                                    : Color
                                                                        .fromARGB(
                                                                            255,
                                                                            240,
                                                                            184,
                                                                            29)),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          GestureDetector(
                                                              onTap: () {
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            const AccountRevise(),
                                                                  ),
                                                                );
                                                              },
                                                              child: Container(
                                                                width: 95,
                                                                height: 35,
                                                                decoration: BoxDecoration(
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            239,
                                                                            247,
                                                                            245),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            20)),
                                                                child: Center(
                                                                    child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: const [
                                                                    Icon(
                                                                        Icons
                                                                            .edit,
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            108,
                                                                            141,
                                                                            133),
                                                                        size:
                                                                            15),
                                                                    Text(
                                                                      "修改資料",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              13,
                                                                          color: Color.fromARGB(
                                                                              255,
                                                                              108,
                                                                              141,
                                                                              133)),
                                                                    ),
                                                                  ],
                                                                )),
                                                              )),
                                                          Container(
                                                            width: 10,
                                                          ),
                                                          GestureDetector(
                                                            onTap:
                                                                getmixcalorie,
                                                            child: Icon(
                                                                Icons.refresh,
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        239,
                                                                        247,
                                                                        245)),
                                                          )
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 20,
                                              ),
                                              Neumorphic(
                                                padding: EdgeInsets.all(20),
                                                style: NeumorphicStyle(
                                                    intensity: 0.9,
                                                    surfaceIntensity: 0.9,
                                                    boxShape: NeumorphicBoxShape
                                                        .circle(),
                                                    depth: -5,
                                                    lightSource:
                                                        LightSource.topRight,
                                                    color: Color.fromARGB(
                                                        255, 238, 238, 238)),
                                                child: Center(
                                                  child: Text(
                                                    mixCalorie.toString(),
                                                    style: TextStyle(
                                                        fontSize: 22,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: sum <= mixCalorie
                                                            ? Color.fromARGB(
                                                                255,
                                                                57,
                                                                161,
                                                                31)
                                                            : Color.fromARGB(
                                                                255,
                                                                240,
                                                                184,
                                                                29)),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ))
                                ]);
                              }
                            } else {
                              return SizedBox(
                                  height: 300,
                                  child: Center(
                                      child: LoadingAnimationWidget
                                          .staggeredDotsWave(
                                    color: kPrimaryColor,
                                    size: 80,
                                  )));
                            }
                          }),
                      const SizedBox(height: 30),
                      const AnalysisBar(),
                      const SizedBox(height: 30),
                      const Consumption(),
                      const SizedBox(height: 30),
                      const WaterIntake(),
                      const SizedBox(height: 80),
                    ]))));
  }
}
