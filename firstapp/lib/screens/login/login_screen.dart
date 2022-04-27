import 'package:firstapp/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:firstapp/screens/home/home_screen.dart';
import 'package:firstapp/screens/login/login_model.dart';
import 'package:http/http.dart' as http;

const users = const {
  'dribbble@gmail.com': '12345',
  'hunter@gmail.com': 'hunter',
};

class LoginScreen extends StatelessWidget {
  Duration get loginTime => Duration(milliseconds: 2250);
  late LoginModel _loginModel;

  Future<String?> _authUser(LoginData data) {
    debugPrint('Name: ${data.name}, Password: ${data.password}');
    print(data.password.runtimeType);
    return Future.delayed(loginTime).then((_) async {
      //if (!users.containsKey(data.name)) {
      //return 'User not exists';
      //}

      //_loginModel = await _createLogin(data.name, data.password);
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
      if (!users.containsKey(name)) {
        return 'User not exists';
      }
      return null;
    });
  }

  Future<LoginModel> _createLogin(String phoneNo, String password) async {
    int timestamp = DateTime.now().millisecondsSinceEpoch + 10;
    var response = await http.post(
        Uri.https(
            "api.einvoice.nat.gov.tw", "/PB2CAPIVAN/Carrier/AppGetBarcode"),
        body: {
          "action": "getBarcode",
          "appID": "EINV0202204156709",
          "phoneNo": phoneNo,
          "timeStamp": timestamp.toString(),
          "uuid": "1000",
          "verificationCode": password,
          "version": "1.0"
        });
    var data = response.body;
    print(data);
    String responseString = response.body;
    return loginModelFromJson(responseString);
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'Cloud-rie',
      theme: LoginTheme(
        accentColor: kSecondaryColor,
        primaryColor: kPrimaryColor,
        cardTheme: CardTheme(
          color: Colors.grey.shade100,
          elevation: 5,
          margin: EdgeInsets.only(top: 15),
          shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(70)),
        ),
      ),
      userType: LoginUserType.phone,
      userValidator: (str) {},
      logo: AssetImage('assets/images/image_1.png'),
      onLogin: _authUser,
      onSignup: _signupUser,
      onSubmitAnimationCompleted: () {
        Navigator.pop(context);
      },
      onRecoverPassword: _recoverPassword,
    );
  }
}
