import 'dart:convert';

LoginModel loginModelFromJson(String str) =>
    LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  LoginModel({
    required this.cardNo,
    required this.phoneNo,
    required this.verificationCode,
    required this.code,
    required this.msg,
    required this.v,
  });

  String cardNo;
  String phoneNo;
  String verificationCode;
  int code;
  String msg;
  String v;

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        cardNo: json["cardNo"],
        phoneNo: json["phoneNo"],
        verificationCode: json["verificationCode"],
        code: json["code"],
        msg: json["msg"],
        v: json["v"],
      );

  Map<String, dynamic> toJson() => {
        "cardNo": cardNo,
        "phoneNo": phoneNo,
        "verificationCode": verificationCode,
        "code": code.toString(),
        "msg": msg,
        "v": v,
      };
}
