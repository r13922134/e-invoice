import 'package:flutter/material.dart';
import 'package:firstapp/screens/analysis/card_info.dart';
import 'package:firstapp/constants.dart';

class DetailPage extends StatelessWidget {
  final CardInfo cardInfo;
  final index;
  const DetailPage({Key? key, required this.cardInfo, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const SizedBox(height: 300),
                        Text(
                          cardInfo.name,
                          style: const TextStyle(
                            fontFamily: 'Avenir',
                            fontSize: 56,
                            color: kTextColor,
                            fontWeight: FontWeight.w900,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        for (String s in cardInfo.calorie)
                          Text(
                            s,
                            style: const TextStyle(
                              fontFamily: 'Avenir',
                              fontSize: 31,
                              color: kTextColor,
                              fontWeight: FontWeight.w300,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        const Divider(color: Colors.black38),
                        const SizedBox(height: 32),
                        const Divider(color: Colors.black38),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 32.0),
                    child: Text(
                      'Gallery',
                      style: TextStyle(
                        fontFamily: 'Avenir',
                        fontSize: 25,
                        color: Color(0xff47455f),
                        fontWeight: FontWeight.w300,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 10,
              right: -30,
              child: Hero(
                  tag: index,
                  child: Image.asset(cardInfo.images ?? '', width: 270)),
            ),
            Positioned(
              top: 60,
              left: 32,
              child: Text(
                cardInfo.position.toString(),
                style: TextStyle(
                  fontFamily: 'Avenir',
                  fontSize: 247,
                  color: kTextColor.withOpacity(0.08),
                  fontWeight: FontWeight.w900,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_back_ios, size: 30),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
