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
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:firstapp/screens/account/components/account_revise.dart';
import 'package:flutter/cupertino.dart';
import 'package:firstapp/screens/home/components/home_barcode.dart';
import 'dart:convert';
import 'dart:math';
import 'package:firstapp/database/winninglist_database.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:quick_actions/quick_actions.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    const Splash(),
  );
}

class Splash extends StatelessWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
        home: AnimatedSplashScreen.withScreenFunction(
            duration: 3000,
            splash: 'assets/images/image_2.png',
            splashIconSize: 65,
            screenFunction: () async {
              updateData();
              return const MyApp();
            },
            splashTransition: SplashTransition.fadeTransition,
            pageTransitionType: PageTransitionType.fade,
            backgroundColor: kPrimaryColor));
  }
}

Future<void> updateData() async {
  List<Header>? responseList2 = await HeaderHelper.instance.getAll();

  if (responseList2.isNotEmpty) {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String barcode = pref.getString('barcode') ?? "";
    String password = pref.getString('password') ?? "";
    var client = http.Client();
    var rng = Random();
    var now = DateTime.now();
    int uuid = rng.nextInt(1000);
    int timestamp = DateTime.now().millisecondsSinceEpoch + 30000;
    int exp = timestamp + 50000;

    var formatter = DateFormat('yyyy/MM/dd');
    String sdate;
    String edate;
    DateTime last;
    DateTime start;
    String term;
    for (int j = 5; j >= 0; j--) {
      uuid = rng.nextInt(1000);

      start = DateTime(now.year, now.month - j, 01);
      last = DateTime(start.year, start.month + 1, 0);
      sdate = formatter.format(start);
      edate = formatter.format(last);
      if (start.month < 10) {
        term = (start.year - 1911).toString() + '0' + start.month.toString();
      } else {
        term = (start.year - 1911).toString() + start.month.toString();
      }
      var rbody1 = {
        "version": "0.5",
        "cardType": "3J0002",
        "cardNo": barcode,
        "expTimeStamp": exp.toString().substring(0, 10),
        "action": "carrierInvChk",
        "timeStamp": timestamp.toString().substring(0, 10),
        "startDate": sdate,
        "endDate": edate,
        "onlyWinningInv": 'N',
        "uuid": uuid.toString(),
        "appID": 'EINV0202204156709',
        "cardEncrypt": password,
      };
      var rbody2 = {
        "version": "0.5",
        "cardType": "3J0002",
        "cardNo": barcode,
        "expTimeStamp": exp.toString().substring(0, 10),
        "action": "carrierInvChk",
        "timeStamp": timestamp.toString().substring(0, 10),
        "startDate": sdate,
        "endDate": edate,
        "onlyWinningInv": 'Y',
        "uuid": uuid.toString(),
        "appID": 'EINV0202204156709',
        "cardEncrypt": password,
      };
      var rbody3 = {
        "version": "0.2",
        "action": "QryWinningList",
        "invTerm": term,
        "UUID": uuid.toString(),
        "appID": "EINV0202204156709",
      };
      try {
        var response = await client.post(
            Uri.parse(
                'https://api.einvoice.nat.gov.tw/PB2CAPIVAN/invServ/InvServ'),
            headers: {
              "Content-Type": "application/x-www-form-urlencoded",
            },
            body: rbody1);
        var response2 = await client.post(
            Uri.parse(
                'https://api.einvoice.nat.gov.tw/PB2CAPIVAN/invServ/InvServ'),
            headers: {
              "Content-Type": "application/x-www-form-urlencoded",
            },
            body: rbody2);
        var response3 = await client.post(
            Uri.parse(
                'https://api.einvoice.nat.gov.tw/PB2CAPIVAN/invapp/InvApp'),
            headers: {
              "Content-Type": "application/x-www-form-urlencoded",
            },
            body: rbody3);
        if (response.statusCode == 200 &&
            response2.statusCode == 200 &&
            response3.statusCode == 200) {
          String responseString = response.body;
          String reString = response2.body;
          String winlist = response3.body;
          var w = jsonDecode(winlist);
          var r = jsonDecode(responseString);
          var re = jsonDecode(reString);

          List d = r['details'];
          List d2 = re['details'];

          int tmpyear;
          DateTime invDate;
          String invdate;
          var formatter = DateFormat('yyyy/MM/dd');
          var t;
          if (d.isNotEmpty) {
            for (var de in d) {
              t = de['invDate'];
              tmpyear = t['year'] + 1911;
              invDate = DateTime(tmpyear, t['month'], t['date']);
              invdate = formatter.format(invDate);
              if (await HeaderHelper.instance
                  .checkHeader(de['invNum'], invdate)) {
                await HeaderHelper.instance.add(Header(
                    tag: t['year'].toString() + t['month'].toString(),
                    date: invdate,
                    time: de['invoiceTime'],
                    seller: de['sellerName'],
                    address: de['sellerAddress'],
                    invNum: de['invNum'],
                    barcode: de['cardNo'],
                    amount: de['amount'],
                    w: 'f'));
              }
            }
          }
          if (d2.isNotEmpty) {
            for (var de in d2) {
              t = de['invDate'];
              tmpyear = t['year'] + 1911;
              invDate = DateTime(tmpyear, t['month'], t['date']);
              invdate = formatter.format(invDate);

              await HeaderHelper.instance.deleteold(de['invNum']);
              await HeaderHelper.instance.add(Header(
                  tag: t['year'].toString() + t['month'].toString(),
                  date: invdate,
                  time: de['invoiceTime'],
                  seller: de['sellerName'],
                  address: de['sellerAddress'],
                  invNum: de['invNum'],
                  barcode: de['cardNo'],
                  amount: de['amount'],
                  w: "500"));
            }
          }
          String tmpterm =
              (start.year - 1911).toString() + start.month.toString();
          if (await WlistHelper.instance.checkWlist(tmpterm) &&
              w['code'] == '200') {
            await WlistHelper.instance.add(WinningList(
              tag: tmpterm,
              superPrizeNo: w['superPrizeNo'],
              firstPrizeNo1: w['firstPrizeNo1'],
              firstPrizeNo2: w['firstPrizeNo2'],
              firstPrizeNo3: w['firstPrizeNo3'],
              spcPrizeNo: w['spcPrizeNo'],
            ));
          }
        }
      } catch (e) {
        debugPrint("$e");
      }
    }

    client.close();
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<CurvedNavigationBarState> _NavKey = GlobalKey();
  final _advancedDrawerController = AdvancedDrawerController();
  final controller = ScrollController();
  int heightValue = 120;
  int weightValue = 30;
  int ageValue = 1;
  List<Disease> _selectedDisease = [];
  String genderValue = '';
  String listString = '';
  String activityValue = '';
  double bmiValue = 10.0;
  //int dailyCalorie = 0;
  String bmirange = '';
  int mixCalorie = 0;
  final quickActions = const QuickActions();

  @override
  void initState(){
    super.initState();
    quickActions.setShortcutItems([
      ShortcutItem(
        type: 'barcode_event',
        localizedTitle: '手機條碼',
        icon: 'icon_barcode_event',
      ),
    ]);
    quickActions.initialize((type) {
      if (type == 'barcode_event'){
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => BarcodeScreen()),
        );
      }
     });

  }

  Future<void> readData() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String? listString = pref.getString('select_diseases');
    if (listString != null) {
      _selectedDisease = Disease.decode(listString);
    }
    genderValue = pref.getString('gender') ?? '';
    heightValue = pref.getInt('height') ?? 120;
    weightValue = pref.getInt('weight') ?? 30;
    ageValue = pref.getInt('age') ?? 1;
    activityValue = pref.getString('activity') ?? '';
    mixCalorie = pref.getInt('mixCalorie') ?? 0;

    setState(() {});
  }

  // ignore: non_constant_identifier_names
  var PagesAll = [
    const HomeScreen(),
    const QRViewExample(),
    const AnalysisScreen(),
    const ProfileScreen()
  ];
  var myindex = 0;

  @override
  Widget build(BuildContext context) {
    return AdvancedDrawer(
      backdropColor: const Color.fromARGB(255, 170, 193, 202),
      controller: _advancedDrawerController,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
      animateChildDecoration: true,
      rtlOpening: false,
      // openScale: 1.0,
      disabledGestures: true,
      childDecoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),

      child: Scaffold(
          extendBody: true,
          backgroundColor: kBackgroundColor,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                color: kPrimaryColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
            ),
            leading: IconButton(
              onPressed: _handleMenuButtonPressed,
              icon: ValueListenableBuilder<AdvancedDrawerValue>(
                valueListenable: _advancedDrawerController,
                builder: (_, value, __) {
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: Icon(
                      value.visible ? Icons.clear : Icons.menu,
                      key: ValueKey<bool>(value.visible),
                    ),
                  );
                },
              ),
            ),
            actions: <Widget>[
              IconButton(
                icon:
                    const Icon(CupertinoIcons.barcode, color: kBackgroundColor),
                onPressed: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BarcodeScreen(),
                    ),
                  ),
                },
              ),
            ],
          ),
          body: Scaffold(
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
                Icon(
                    (myindex == 3)
                        ? Icons.person
                        : Icons.perm_contact_cal_rounded,
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
          )),
      drawer: SafeArea(
        child: ListTileTheme(
          textColor: Colors.white,
          iconColor: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                width: 120.0,
                height: 120.0,
                margin: const EdgeInsets.only(
                  top: 35.0,
                  bottom: 34.0,
                ),
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(
                  color: Colors.black26,
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  'assets/images/image_1.png',
                ),
              ),
              ListTile(
                onTap: () {},
                leading: const Icon(Icons.supervisor_account_outlined),
                title: Text(genderValue),
              ),
              ListTile(
                onTap: () {},
                leading: const Icon(Icons.edit),
                title: Text("$ageValue   歲"),
              ),
              ListTile(
                onTap: () {},
                leading: const Icon(Icons.boy),
                title: Text("$heightValue   cm"),
              ),
              ListTile(
                onTap: () {},
                leading: const Icon(Icons.accessibility),
                title: Text("$weightValue   kg"),
              ),
              ListTile(
                onTap: () {},
                leading: const Icon(Icons.directions_walk_outlined),
                title: Text(activityValue),
              ),
              ListTile(
                onTap: () {},
                leading: const Icon(Icons.flag_outlined),
                title: Text("$mixCalorie kcal"),
              ),
              ListTile(
                onTap: () {},
                leading: Image.asset('assets/icons/bmi.svg',
                    color: Colors.white, width: 30),
                title: Text(bmirange),
              ),
              const SizedBox(height: 18),
              Row(
                children: <Widget>[
                  const Text("     "),
                  const Icon(Icons.medical_information_outlined,
                      color: Colors.white),
                  const Text("        "),
                  for (Disease value in _selectedDisease)
                    Text(value.name.toString() + ' ',
                        style: const TextStyle(color: Colors.white))
                ],
              ),
              const Spacer(),
              DefaultTextStyle(
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white54,
                ),
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 16.0,
                  ),
                  child: const Text('Terms of Service | Privacy Policy'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleMenuButtonPressed() async {
    await readData();

    _advancedDrawerController.showDrawer();
  }
}
