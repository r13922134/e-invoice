import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:lottie/lottie.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Consumption extends StatefulWidget {
  const Consumption({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ConsumptionState();
}

class ConsumptionState extends State<Consumption> {
  int weight = 0;
  Future getWeight() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    weight = pref.getInt('weight') ?? 0;
  }

  List<String> sport = [
    '慢走(4km/hr)',
    '快走/健走(6km/hr)',
    '慢跑(8km/hr)',
    '快跑(16km/hr)',
    '騎腳踏車(20km/hr)',
    '瑜珈',
    '游泳(25m/min)',
    '跳繩(100下/min)'
  ];
  List<String> img = [
    'assets/slow.json',
    'assets/fast.json',
    'assets/jogging.json',
    'assets/run.json',
    'assets/bike.json',
    'assets/yoga.json',
    'assets/swim.json',
    'assets/jump-rope.json'
  ];
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getWeight(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            int range = 0;
            List<List<String>> l = [
              ['70', '110', '164', '336', '168', '60', '126', '168'],
              ['87.5', '137.5', '205', '420', '210', '75', '157.5', '210'],
              ['105', '165', '246', '504', '252', '90', '189', '252'],
              ['122', '192', '287', '558', '294', '105', '220.5', '294']
            ];
            if (weight <= 40) {
              range = 0;
            } else if (weight > 40 && weight <= 50) {
              range = 1;
            } else if (weight > 50 && weight <= 60) {
              range = 2;
            } else {
              range = 3;
            }

            return Container(
                height: 120,
                width: 500,
                child: Swiper(
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              Container(
                                height: 150,
                                width: 150,
                                child: Lottie.asset(
                                  img[7 - index],
                                ),
                              ),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(sport[7 - index],
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w900,
                                          color:
                                              Color.fromARGB(255, 71, 75, 62))),
                                  Row(
                                    children: [
                                      Text(l[range][7 - index] + ' kcal',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w900,
                                              color: Color.fromARGB(
                                                  255, 31, 99, 51))),
                                      Text(' /30min',
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: Color.fromARGB(
                                                  255, 159, 162, 165))),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          )),
                      color: Color.fromARGB(255, 252, 247, 202),
                      // elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                    );
                  },
                  itemCount: 8,
                  viewportFraction: 0.7,
                  scale: 0.7,
                  itemWidth: 330,
                  layout: SwiperLayout.STACK,
                ));
          }
          return SizedBox(
              height: 10,
              child: Center(
                  child: LoadingAnimationWidget.inkDrop(
                color: Color.fromARGB(255, 255, 245, 155),
                size: 60,
              )));
        });
  }
}
