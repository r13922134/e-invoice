import 'package:flutter/material.dart';
import 'profile_menu.dart';
import 'profile_pic.dart';
import 'package:firstapp/screens/account/components/account_revise.dart';
import 'package:firstapp/screens/login/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cool_alert/cool_alert.dart';
import '../../../constants.dart';
import 'package:firstapp/database/invoice_database.dart';
import 'package:firstapp/database/details_database.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  ProfileBody createState() => ProfileBody();
}

class ProfileBody extends State<Body> {
  String barcode = '';

  Future<String> getBarcode() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    barcode = pref.getString('barcode') ?? 'null';

    return barcode;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: getBarcode(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data == 'null') {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: [
                    const ProfilePic(),
                    const SizedBox(height: 20),
                    ProfileMenu(
                      text: "基本資料",
                      icon: "assets/icons/User Icon.svg",
                      press: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AccountRevise(),
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
                      text: "登入",
                      icon: "assets/icons/Log in.svg",
                      press: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        ),
                      },
                    ),
                  ],
                ),
              );
            } else {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: [
                    const ProfilePic(),
                    const SizedBox(height: 20),
                    ProfileMenu(
                      text: "基本資料",
                      icon: "assets/icons/User Icon.svg",
                      press: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AccountRevise(),
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
                        text: "登出",
                        icon: "assets/icons/Log out.svg",
                        press: () => {
                              CoolAlert.show(
                                context: context,
                                type: CoolAlertType.confirm,
                                confirmBtnColor: kPrimaryColor,
                                onConfirmBtnTap: () async {
                                  await HeaderHelper.instance.delete();
                                  await DetailHelper.instance.delete();
                                  SharedPreferences pref =
                                      await SharedPreferences.getInstance();
                                  await pref.clear();
                                  setState(() {});
                                  showTopSnackBar(
                                    context,
                                    const CustomSnackBar.success(
                                      message: "登出成功",
                                      backgroundColor: kSecondaryColor,
                                    ),
                                  );
                                  Navigator.pop(context);
                                },
                                text: "登出確認",
                              )
                            }),
                  ],
                ),
              );
            }
          } else {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  const ProfilePic(),
                  const SizedBox(height: 20),
                  ProfileMenu(
                    text: "基本資料",
                    icon: "assets/icons/User Icon.svg",
                    press: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AccountRevise(),
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
                ],
              ),
            );
          }
        });
  }
}
