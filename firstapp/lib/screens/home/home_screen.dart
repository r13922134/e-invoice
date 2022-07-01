import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:firstapp/screens/home/components/body.dart';
import '../../../constants.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firstapp/screens/account/components/account_revise.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  _IdentityPageState createState() => _IdentityPageState();
}

class _IdentityPageState extends State<HomeScreen> {
  final _advancedDrawerController = AdvancedDrawerController();

  int heightValue = 120;
  int weightValue = 30;
  int ageValue = 1;
  List<Disease> _selectedDisease = [];
  String genderValue = '';
  String listString = '';

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

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    readData();
  }

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
        ),
        body: const Body(),
      ),
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
