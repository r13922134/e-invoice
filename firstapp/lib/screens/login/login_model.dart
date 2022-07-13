import 'dart:convert';
import 'package:firstapp/database/invoice_database.dart';
import 'package:intl/intl.dart';

void loginModelFromJson(String str) async {
  List<Detail> tmp = LoginModel.fromJson(json.decode(str)).details;
  int tmpyear;
  DateTime invDate;
  String invdate;
  var formatter = DateFormat('yyyy/MM/dd');

  for (Detail element in tmp) {
    tmpyear = element.invDate.year + 1911;
    invDate = DateTime(tmpyear, element.invDate.month, element.invDate.date);
    invdate = formatter.format(invDate);
    if (await HeaderHelper.instance.checkHeader(element.invNum, invdate)) {
      await HeaderHelper.instance.add(Header(
          tag: element.invDate.year.toString() +
              element.invDate.month.toString(),
          date: invdate,
          time: element.invoiceTime,
          seller: element.sellerName,
          address: element.sellerAddress,
          invNum: element.invNum,
          barcode: element.cardNo,
          amount: element.amount));
    }
  }
}

// String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  LoginModel({
    required this.v,
    required this.code,
    required this.msg,
    required this.onlyWinningInv,
    required this.details,
  });

  String v;
  int code;
  String msg;
  String onlyWinningInv;
  List<Detail> details;

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        v: json["v"],
        code: json["code"],
        msg: json["msg"],
        onlyWinningInv: json["onlyWinningInv"],
        details:
            List<Detail>.from(json["details"].map((x) => Detail.fromJson(x))),
      );

  // Map<String, dynamic> toJson() => {
  //       "v": v,
  //       "code": code,
  //       "msg": msg,
  //       "onlyWinningInv": onlyWinningInv,
  //       "details": List<dynamic>.from(details.map((x) => x.toJson())),
  //     };
}

class Detail {
  Detail({
    required this.rowNum,
    required this.invNum,
    required this.cardType,
    required this.cardNo,
    required this.sellerName,
    required this.invStatus,
    required this.invDonatable,
    required this.amount,
    required this.invPeriod,
    required this.donateMark,
    required this.invDate,
    required this.sellerBan,
    required this.sellerAddress,
    required this.invoiceTime,
    required this.buyerBan,
    required this.currency,
  });

  int rowNum;
  String invNum;
  String cardType;
  String cardNo;
  String sellerName;
  String invStatus;
  bool invDonatable;
  String amount;
  String invPeriod;
  int donateMark;
  InvDate invDate;
  String sellerBan;
  String sellerAddress;
  String invoiceTime;
  String buyerBan;
  String currency;

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
        rowNum: json["rowNum"],
        invNum: json["invNum"],
        cardType: json["cardType"],
        cardNo: json["cardNo"],
        sellerName: json["sellerName"],
        invStatus: json["invStatus"],
        invDonatable: json["invDonatable"],
        amount: json["amount"],
        invPeriod: json["invPeriod"],
        donateMark: json["donateMark"],
        invDate: InvDate.fromJson(json["invDate"]),
        sellerBan: json["sellerBan"],
        sellerAddress: json["sellerAddress"],
        invoiceTime: json["invoiceTime"],
        buyerBan: json["buyerBan"],
        currency: json["currency"],
      );

  // Map<String, dynamic> toJson() => {
  //       "rowNum": rowNum,
  //       "invNum": invNum,
  //       "cardType": cardType,
  //       "cardNo": cardNo,
  //       "sellerName": sellerName,
  //       "invStatus": invStatus,
  //       "invDonatable": invDonatable,
  //       "amount": amount,
  //       "invPeriod": invPeriod,
  //       "donateMark": donateMark,
  //       "invDate": invDate.toJson(),
  //       "sellerBan": sellerBan,
  //       "sellerAddress": sellerAddress,
  //       "invoiceTime": invoiceTime,
  //       "buyerBan": buyerBan,
  //       "currency": currency,
  //     };
}

class InvDate {
  InvDate({
    required this.year,
    required this.month,
    required this.date,
    required this.day,
    required this.hours,
    required this.minutes,
    required this.seconds,
    required this.time,
    required this.timezoneOffset,
  });

  int year;
  int month;
  int date;
  int day;
  int hours;
  int minutes;
  int seconds;
  int time;
  int timezoneOffset;

  factory InvDate.fromJson(Map<String, dynamic> json) => InvDate(
        year: json["year"],
        month: json["month"],
        date: json["date"],
        day: json["day"],
        hours: json["hours"],
        minutes: json["minutes"],
        seconds: json["seconds"],
        time: json["time"],
        timezoneOffset: json["timezoneOffset"],
      );

  // Map<String, dynamic> toJson() => {
  //       "year": year,
  //       "month": month,
  //       "date": date,
  //       "day": day,
  //       "hours": hours,
  //       "minutes": minutes,
  //       "seconds": seconds,
  //       "time": time,
  //       "timezoneOffset": timezoneOffset,
  //     };
}
