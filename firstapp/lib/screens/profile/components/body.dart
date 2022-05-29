import 'package:flutter/material.dart';
import 'profile_menu.dart';
import 'profile_pic.dart';
import 'package:firstapp/screens/account/account_screen.dart';
import 'package:firstapp/screens/login/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cool_alert/cool_alert.dart';
import '../../../constants.dart';
import 'package:firstapp/database/invoice_database.dart';
import 'package:firstapp/database/details_database.dart';

class Body extends StatefulWidget {
  @override
  ProfileBody createState() => ProfileBody();
}

class ProfileBody extends State<Body> {
  late String barcode;

  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          ProfilePic(),
          SizedBox(height: 20),
          ProfileMenu(
            text: "My Account",
            icon: "assets/icons/User Icon.svg",
            press: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AccountScreen(),
                ),
              ),
            },
          ),
          ProfileMenu(
            text: "Notifications",
            icon: "assets/icons/Bell.svg",
            press: () {},
          ),
          ProfileMenu(
            text: "Settings",
            icon: "assets/icons/Settings.svg",
            press: () {},
          ),
          ProfileMenu(
            text: "Help Center",
            icon: "assets/icons/Question mark.svg",
            press: () {},
          ),
          ProfileMenu(
            text: "Log In",
            icon: "assets/icons/Log out.svg",
            press: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginScreen(),
                ),
              ),
            },
          ),
          ProfileMenu(
              text: "Log Out",
              icon: "assets/icons/Log out.svg",
              press: () => {
                    CoolAlert.show(
                      context: context,
                      type: CoolAlertType.confirm,
                      confirmBtnColor: kPrimaryColor,
                      onConfirmBtnTap: () async {
                        await HeaderHelper.instance.delete();
                        await DetailHelper.instance.delete();
                        Navigator.pop(context);
                        
                      },
                      text: "登出確認",
                    )
                  }),
        ],
      ),
    );
  }
}
