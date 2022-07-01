import 'package:flutter/material.dart';
import 'package:firstapp/constants.dart';
import 'package:firstapp/screens/home/home_screen.dart';
import 'package:firstapp/screens/profile/profile_screen.dart';
import 'package:firstapp/screens/scan/scan_screen.dart';
import 'package:firstapp/screens/analysis/analysis_screen.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:firstapp/database/invoice_database.dart';
import 'package:intl/intl.dart';
import 'package:firstapp/screens/login/login_model.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      scaffoldBackgroundColor: kBackgroundColor,
      primarySwatch: Colors.blueGrey,
      primaryColor: kPrimaryColor,
      textTheme: const TextTheme(
        bodyText2: TextStyle(color: kTextColor),
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
    home: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GlobalKey<CurvedNavigationBarState> _NavKey = GlobalKey();
  // ignore: non_constant_identifier_names
  var PagesAll = [
    const HomeScreen(),
    const QRViewExample(),
    const AnalysisScreen(),
    const ProfileScreen()
  ];
  var myindex = 0;

  void UpdateData() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String barcode = pref.getString('barcode') ?? "";
    String password = pref.getString('password') ?? "";

    var now = DateTime.now();
    List<Header>? responseList2 = await HeaderHelper.instance.getHeader();
    if (responseList2 != []) {
      String tmpTag = responseList2[responseList2.length - 1].tag;
      await HeaderHelper.instance.deleteMonth(tmpTag);
      String tmpDate = responseList2[responseList2.length - 1].date;
      final splitted = tmpDate.split('/');
      int tmpYear = int.parse(splitted[0]);
      int tmpMonth = int.parse(splitted[1]);

      int timestamp = DateTime.now().millisecondsSinceEpoch + 30;
      int exp = timestamp + 200;
      var formatter = DateFormat('yyyy/MM/dd');
      String responseString;
      String sdate;
      String edate;
      DateTime last;
      DateTime start;
      http.Response response;

      while (true) {
        start = DateTime(tmpYear, tmpMonth, 01);
        last = DateTime(tmpYear, tmpMonth + 1, 0);
        sdate = formatter.format(start);
        edate = formatter.format(last);
        response = await http.post(
            Uri.https("api.einvoice.nat.gov.tw", "PB2CAPIVAN/invServ/InvServ"),
            body: {
              "version": "0.5",
              "cardType": "3J0002",
              "cardNo": barcode,
              "expTimeStamp": exp.toString(),
              "action": "carrierInvChk",
              "timeStamp": timestamp.toString(),
              "startDate": sdate,
              "endDate": edate,
              "onlyWinningInv": 'N',
              "uuid": '1000',
              "appID": 'EINV0202204156709',
              "cardEncrypt": password,
            });
        responseString = response.body;
        loginModelFromJson(responseString);
        if (start.year == now.year && start.month == now.month) {
          break;
        }
        tmpMonth += 1;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    UpdateData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: CurvedNavigationBar(
        height: 64,
        backgroundColor: Colors.transparent,
        key: _NavKey,
        items: [
          Icon((myindex == 0) ? Icons.cloud_upload : Icons.home,
              color: kBackgroundColor),
          Icon(
              (myindex == 1)
                  ? Icons.qr_code_2_outlined
                  : Icons.add_a_photo_rounded,
              color: kBackgroundColor),
          Icon((myindex == 2) ? Icons.insights_outlined : Icons.fastfood,
              color: kBackgroundColor),
          Icon((myindex == 3) ? Icons.person : Icons.perm_contact_cal_rounded,
              color: kBackgroundColor),
        ],
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
