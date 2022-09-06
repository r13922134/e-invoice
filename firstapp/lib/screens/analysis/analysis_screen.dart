import 'package:firstapp/constants.dart';
import 'package:flutter/material.dart';
import 'package:firstapp/screens/analysis/analysis_bar.dart';
import 'package:firstapp/screens/analysis/water_intake_progressbar.dart';
import 'package:firstapp/screens/analysis/water_intake_timeline.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:firstapp/screens/analysis/card_info.dart';
import 'package:firstapp/screens/analysis/card_detail.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

DateTime now = DateTime.now();
DateTime date = DateTime(now.year, now.month, now.day);
List<String> splitted = date.toString().split('-');
String tmpdate =
    splitted[0] + '/' + splitted[1] + '/' + splitted[2][0] + splitted[2][1];

class AnalysisScreen extends StatefulWidget {
  const AnalysisScreen({Key? key}) : super(key: key);
  @override
  _IdentityPageState createState() => _IdentityPageState();
}

class _IdentityPageState extends State<AnalysisScreen> {
  String bmirange = '';
  String _date = tmpdate;

  Future<void> readData() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    bmirange = pref.getString('bmirange') ?? '';

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
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
                              List<CardInfo> tcards = snapshot.data;
                              if (snapshot.data?.isEmpty ?? true) {
                                return SizedBox(
                                    height: 300,
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
                                int len = tcards.length - 1;

                                return Swiper(
                                  index: len,
                                  onTap: (index) {
                                    Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder: (context, a, b) =>
                                            DetailPage(
                                          cardInfo: tcards[len - index],
                                          index: index,
                                        ),
                                      ),
                                    );
                                  },
                                  itemCount: tcards.length,
                                  itemWidth: MediaQuery.of(context).size.width -
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
                                                      BorderRadius.circular(32),
                                                ),
                                                color: Colors.white,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
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
                                                      tcards[len - index]
                                                                  .name
                                                                  .length <
                                                              14
                                                          ? Text(
                                                              tcards[len -
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
                                                              tcards[len -
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
                                                      Text(
                                                        "x" +
                                                            tcards[len - index]
                                                                .quantity,
                                                        style: const TextStyle(
                                                          fontFamily: 'Avenir',
                                                          fontSize: 30,
                                                          color:
                                                              Color(0xff47455f),
                                                          fontWeight:
                                                              FontWeight.w900,
                                                        ),
                                                        textAlign:
                                                            TextAlign.left,
                                                      ),
                                                      const SizedBox(
                                                          height: 10),
                                                      Row(
                                                        children: const <
                                                            Widget>[
                                                          Text(
                                                            '設定熱量',
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Avenir',
                                                              fontSize: 18,
                                                              color: kTextColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                            textAlign:
                                                                TextAlign.left,
                                                          ),
                                                          Icon(
                                                            Icons.arrow_forward,
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
                                                tcards[len - index].images ??
                                                    '',
                                                width: 120),
                                          ),
                                          Positioned(
                                            right: 24,
                                            bottom: 1,
                                            child: Text(
                                              tcards[len - index]
                                                  .position
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
                                );
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
                      const SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        height: 145,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: const Color.fromARGB(255, 110, 136, 148)),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            children: [
                              Flexible(
                                child: SizedBox(
                                  width: (size.width),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "BMI (Body Mass Index)",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                      Text(
                                        "You have a $bmirange weight",
                                        style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.white),
                                      ),
                                      Container(
                                        width: 95,
                                        height: 35,
                                        decoration: BoxDecoration(
                                            color: kSecondaryColor,
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: const Center(
                                          child: Text(
                                            "View More",
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.white),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Container(
                                width: 100,
                                height: 100,
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: kBackgroundColor),
                                child: const Center(
                                  child: Text(
                                    "20.3",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Color.fromARGB(255, 57, 161, 31)),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const AnalysisBar(),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Container(
                            width: (size.width - 80) / 2,
                            height: 320,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black.withOpacity(0.01),
                                      spreadRadius: 20,
                                      blurRadius: 10,
                                      offset: const Offset(0, 10))
                                ],
                                borderRadius: BorderRadius.circular(30)),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Row(
                                children: [
                                  const WateIntakeProgressBar(),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Flexible(
                                    child: Column(
                                      children: [
                                        const Text(
                                          "Water Intake",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const Spacer(),
                                        Column(
                                          children: [
                                            Text(
                                              "Real time updates",
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.black
                                                      .withOpacity(0.5)),
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            const WaterIntakeTimeLine()
                                          ],
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 70),
                    ]))));
  }
}
