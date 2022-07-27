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
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:firstapp/screens/account/components/account_revise.dart';
import 'package:flutter/cupertino.dart';
import 'package:firstapp/screens/home/components/home_barcode.dart';
import 'package:firstapp/screens/analysis/calculate.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  updateData();

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

void updateData() async {
  final SharedPreferences pref = await SharedPreferences.getInstance();
  String barcode = pref.getString('barcode') ?? "";
  String password = pref.getString('password') ?? "";

  var now = DateTime.now();
  List<Header>? responseList2 = await HeaderHelper.instance.getAll();

  if (responseList2.isNotEmpty) {
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

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GlobalKey<CurvedNavigationBarState> _NavKey = GlobalKey();
  final _advancedDrawerController = AdvancedDrawerController();
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
    activityValue = pref.getString('activity')?? '';
    Calculate c = new Calculate(
                      height: heightValue,
                      weight: weightValue,
                      gender: genderValue,
                      activity: activityValue);
    c.calculateBMI();
    bmirange = c.getInterpretation();
    if(ageValue>18){
      mixCalorie = c.getdailyCalorie();
    }
    else if(ageValue>15){
      mixCalorie = c.getdailyCalorie_teenager();
    }
    else if(ageValue>=13){
      mixCalorie = c.getdailyCalorie_child();
    }
    else{
      mixCalorie = 1200;
    }

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
      disabledGestures: false,
      childDecoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),

      child: Scaffold(
          extendBody: true,
          backgroundColor: kBackgroundColor,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
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
                width: 128.0,
                height: 128.0,
                margin: const EdgeInsets.only(
                  top: 24.0,
                  bottom: 64.0,
                ),
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(
                  color: Colors.black26,
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  'assets/images/logo.png',
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
                title: Text("$ageValue"),
              ),
              ListTile(
                onTap: () {},
                leading: const Icon(Icons.boy),
                title: Text("$heightValue"),
              ),
              ListTile(
                onTap: () {},
                leading: const Icon(Icons.accessibility),
                title: Text("$weightValue"),
              ),
              ListTile(
                onTap: () {},
                leading: const Icon(Icons.directions_walk_outlined),
                title: Text("$activityValue"),
              ),
              ListTile(
                onTap: () {},
                leading: const Icon(Icons.flag_outlined),
                title: Text("$mixCalorie kcal"),
              ),
              ListTile(
                onTap: () {},
                leading: const Icon(Icons.flag_outlined),
                title: Text("$bmirange"),
              ),
              const SizedBox(height: 18),
              Row(
                children: <Widget>[
                  Text("    "),
                  const Icon(Icons.medical_information_outlined,
                      color: Colors.white),
                  Text("        "),
                  for (Disease value in _selectedDisease)
                    Text(value.name.toString() + ' ',
                        style: TextStyle(color: Colors.white))
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
