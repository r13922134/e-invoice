import 'package:firstapp/constants.dart';
import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:lottie/lottie.dart';

class Consumption extends StatefulWidget {
  const Consumption({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ConsumptionState();
}

class ConsumptionState extends State<Consumption> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 120,
        width: 500,
        child: Swiper(
          itemBuilder: (BuildContext context, int index) {
            return Card(
              child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      Lottie.asset('assets/scan.json', width: 100, height: 100),
                      Text("100")
                    ],
                  )),
              color: kSecondaryColor,
              // elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32),
              ),
            );
          },
          itemCount: 10,
          viewportFraction: 0.7,
          scale: 0.7,
          itemWidth: 330,
          layout: SwiperLayout.STACK,
        ));
  }
}
