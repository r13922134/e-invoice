import 'package:firstapp/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:firstapp/screens/login/login_model.dart';
import 'package:http/http.dart' as http;
import '../../../constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:firstapp/database/invoice_database.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  Duration get loginTime => const Duration(seconds: 1);

  Future<void> setDevice(barcode, password) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('barcode', barcode);
    pref.setString('password', password);
  }

  Future<String?> _authUser(LoginData data) {
    debugPrint('Name: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then((_) async {
      setDevice(data.name, data.password);

      int timestamp = DateTime.now().millisecondsSinceEpoch + 20;
      int exp = timestamp + 300;
      var now = DateTime.now();
      var formatter = DateFormat('yyyy/MM/dd');
      List<Detail> tmp = [];
      String responseString;
      String sdate;
      String edate;
      DateTime last;
      DateTime start;
      http.Response response;
      int tmpyear;
      DateTime invDate;
      String invdate;

      for (int j = 5; j >= 0; j--) {
        start = DateTime(now.year, now.month - j, 01);
        last = DateTime(start.year, start.month + 1, 0);
        sdate = formatter.format(start);
        edate = formatter.format(last);
        response = await http.post(
            Uri.https("api.einvoice.nat.gov.tw", "PB2CAPIVAN/invServ/InvServ"),
            body: {
              "version": "0.5",
              "cardType": "3J0002",
              "cardNo": data.name,
              "expTimeStamp": exp.toString(),
              "action": "carrierInvChk",
              "timeStamp": timestamp.toString(),
              "startDate": sdate,
              "endDate": edate,
              "onlyWinningInv": 'N',
              "uuid": '1000',
              "appID": 'EINV0202204156709',
              "cardEncrypt": data.password,
            });
        responseString = response.body;
        debugPrint(responseString);
        tmp = loginModelFromJson(responseString).details;

        for (int i = 0; i < tmp.length; i++) {
          tmpyear = tmp[i].invDate.year + 1911;
          invDate =
              DateTime(tmpyear, tmp[i].invDate.month, tmp[i].invDate.date);
          invdate = formatter.format(invDate);

          await HeaderHelper.instance.add(Header(
              tag: tmp[i].invDate.year.toString() +
                  tmp[i].invDate.month.toString(),
              date: invdate,
              time: tmp[i].invoiceTime,
              seller: tmp[i].sellerName,
              address: tmp[i].sellerAddress,
              invNum: tmp[i].invNum,
              barcode: tmp[i].cardNo,
              amount: tmp[i].amount));
        }
      }

      return null;
    });
  }

  Future<String?> _signupUser(SignupData data) {
    debugPrint('Signup Name: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then((_) {
      return null;
    });
  }

  Future<String?> _recoverPassword(String name) {
    debugPrint('Name: $name');
    return Future.delayed(loginTime).then((_) {
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'Cloud-rie',
      messages: LoginMessages(
          userHint: "手機條碼", passwordHint: "驗證碼", loginButton: "登入"),
      theme: LoginTheme(
        accentColor: kSecondaryColor,
        primaryColor: kPrimaryColor,
        cardTheme: CardTheme(
          color: Colors.grey.shade100,
          elevation: 5,
          margin: const EdgeInsets.only(top: 15),
          shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(70)),
        ),
      ),
      userType: LoginUserType.name,
      userValidator: (str) {
        return null;
      },
      logo: const AssetImage('assets/images/image_1.png'),
      onLogin: _authUser,
      onSignup: _signupUser,
      onSubmitAnimationCompleted: () {
        Navigator.pop(context);
      },
      onRecoverPassword: _recoverPassword,
    );
  }
}
