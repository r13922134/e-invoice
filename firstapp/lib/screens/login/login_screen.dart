import 'package:firstapp/constants.dart';
import 'package:firstapp/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:http/http.dart' as http;
import '../../../constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'dart:convert';
import 'package:firstapp/database/invoice_database.dart';
import 'package:firstapp/database/winninglist_database.dart';
import 'dart:math';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  Duration get loginTime => const Duration(seconds: 0);

  Future<String?> _authUser(LoginData data) async {
    debugPrint('Name: ${data.name}, Password: ${data.password}');
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('barcode', data.name);
    pref.setString('password', data.password);

    int timestamp = DateTime.now().millisecondsSinceEpoch + 25000;
    int exp = timestamp + 65000;
    var now = DateTime.now();
    var formatter = DateFormat('yyyy/MM/dd');
    String responseString;
    String winlist;
    String sdate;
    String edate;
    DateTime last;
    DateTime start;
    var rng = Random();
    int uuid;
    String term;

    var client = http.Client();

    for (int j = 5; j >= 0; j--) {
      uuid = rng.nextInt(1000);

      start = DateTime(now.year, now.month - j, 01);
      last = DateTime(start.year, start.month + 1, 0);
      if (start.month < 10) {
        term = (start.year - 1911).toString() + '0' + start.month.toString();
      } else {
        term = (start.year - 1911).toString() + start.month.toString();
      }
      timestamp += 5000;
      exp += 5000;
      sdate = formatter.format(start);
      edate = formatter.format(last);
      var rbody = {
        "version": "0.5",
        "cardType": "3J0002",
        "cardNo": data.name,
        "expTimeStamp": exp.toString().substring(0, 10),
        "action": "carrierInvChk",
        "timeStamp": timestamp.toString().substring(0, 10),
        "startDate": sdate,
        "endDate": edate,
        "onlyWinningInv": 'N',
        "uuid": uuid.toString(),
        "appID": 'EINV0202204156709',
        "cardEncrypt": data.password,
      };
      var rbody2 = {
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
            body: rbody);
        var response2 = await client.post(
            Uri.parse(
                'https://api.einvoice.nat.gov.tw/PB2CAPIVAN/invapp/InvApp'),
            headers: {
              "Content-Type": "application/x-www-form-urlencoded",
            },
            body: rbody2);
        if (response.statusCode == 200 && response2.statusCode == 200) {
          responseString = response.body;
          winlist = response2.body;
          var w = jsonDecode(winlist);
          var r = jsonDecode(responseString);

          List d = r['details'];
          int tmpyear;
          DateTime invDate;
          String invdate;
          var formatter = DateFormat('yyyy/MM/dd');
          var t;
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

          if (w['code'] == '200') {
            String tmpterm =
                (start.year - 1911).toString() + start.month.toString();
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

    return null;
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
      logo: const AssetImage('assets/images/image_2.png'),
      onLogin: _authUser,
      onSignup: _signupUser,
      onSubmitAnimationCompleted: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const MyApp(),
          ),
        );
        showTopSnackBar(
          context,
          const CustomSnackBar.success(
            message: "登入成功",
            backgroundColor: kSecondaryColor,
          ),
        );
      },
      onRecoverPassword: _recoverPassword,
    );
  }
}
