import 'package:flutter/material.dart';
import 'package:firstapp/constants.dart';
import 'package:firstapp/screens/home/home_screen.dart';
import 'package:firstapp/screens/profile/profile_screen.dart';
import 'package:firstapp/screens/scan/scan_screen.dart';
import 'package:firstapp/screens/analysis/analysis_screen.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      scaffoldBackgroundColor: kBackgroundColor,
      primaryColor: kPrimaryColor,
      textTheme: TextTheme(
        bodyText2: TextStyle(color: kTextColor),
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GlobalKey<CurvedNavigationBarState> _NavKey = GlobalKey();
  var PagesAll = [
    HomeScreen(),
    ScanScreen(),
    AnalysisScreen(),
    ProfileScreen()
  ];
  var myindex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        key: _NavKey,
        items: [
          Icon((myindex == 0) ? Icons.home_outlined : Icons.home),
          Icon((myindex == 1)
              ? Icons.qr_code_2_outlined
              : Icons.add_a_photo_rounded),
          Icon((myindex == 2) ? Icons.insights_outlined : Icons.fastfood),
          Icon((myindex == 3)
              ? Icons.perm_identity
              : Icons.perm_contact_cal_rounded),
        ],
        buttonBackgroundColor: kBackgroundColor,
        onTap: (index) {
          setState(() {
            myindex = index;
          });
        },
        animationCurve: Curves.fastLinearToSlowEaseIn,
        color: kPrimaryColor,
      ),
      body: PagesAll[myindex],
    );
  }
}
