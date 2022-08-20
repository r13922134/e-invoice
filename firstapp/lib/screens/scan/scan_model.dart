import 'dart:convert';
import 'package:firstapp/database/invoice_database.dart';
import 'package:firstapp/database/details_database.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class returnValue {
  returnValue({required this.seller, required this.amount});
  String seller;
  String amount;
}

Future<returnValue> scanModelFromJson(String str, String random) async {
  final SharedPreferences pref = await SharedPreferences.getInstance();
  String? barcode = pref.getString('barcode') ?? "";

  int len = barcode.length;
  String uuid = barcode.substring(1, len);
  ScanModel tmp = ScanModel.fromJson(json.decode(str));
  String tmpdate = tmp.invDate.substring(0, 4) +
      '/' +
      tmp.invDate.toString().substring(4, 6) +
      '/' +
      tmp.invDate.toString().substring(6, 8);

  int tmpyear = int.parse(tmpdate.substring(0, 4)) - 1911;
  int tmpmonth = int.parse(tmpdate.substring(5, 7));
  String tag = tmpyear.toString() + tmpdate.substring(5, 7);
  String tmptag;
  if (tmpmonth % 2 != 0) {
    tmptag = (int.parse(tag) + 1).toString();
  } else {
    tmptag = tag;
  }

  int amount = 0;
  var client = http.Client();
  try {
    var response = await client.post(
        Uri.https("api.einvoice.nat.gov.tw", "PB2CAPIVAN/invapp/InvApp"),
        body: {
          "version": "0.5",
          "type": "Barcode",
          "invNum": tmp.invNum,
          "action": "qryInvDetail",
          "generation": "V2",
          "invTerm": tmptag,
          "invDate": tmpdate,
          "encrypt": "11",
          "sellerID": "11",
          "UUID": uuid,
          "randomNumber": random,
          "appID": "EINV0202204156709",
        });
    String responseString2 = response.body;
    if (responseString2 != '') {
      await scanDetailModelFromJson(responseString2).then((value) {
        if (tag[3] == "0") {
          tag = tag.substring(0, 3) + tag.substring(4, 5);
        }
        List<String> splitted;
        for (Details element in value.details) {
          splitted = element.quantity.split('.');

          DetailHelper.instance.add(invoice_details(
              tag: tag,
              invNum: tmp.invNum,
              name: element.description,
              date: tmpdate,
              quantity: splitted[0],
              amount: element.amount));
          amount += int.parse(element.amount);
        }
      });

      await HeaderHelper.instance.add(Header(
          tag: tag,
          date: tmpdate,
          time: tmp.invoiceTime,
          seller: tmp.sellerName,
          address: tmp.sellerAddress,
          invNum: tmp.invNum,
          barcode: "Scan",
          amount: amount.toString()));
    }
  } catch (e) {
    print("error");
  } finally {
    client.close();
  }

  return returnValue(seller: tmp.sellerName, amount: amount.toString());
}

Future<ScanDetailModel> scanDetailModelFromJson(String str) async {
  return ScanDetailModel.fromJson(json.decode(str));
}

class ScanDetailModel {
  ScanDetailModel({
    required this.v,
    required this.code,
    required this.msg,
    required this.invNum,
    required this.invDate,
    required this.sellerName,
    required this.invStatus,
    required this.invPeriod,
    required this.sellerBan,
    required this.sellerAddress,
    required this.invoiceTime,
    required this.buyerBan,
    required this.currency,
    required this.details,
  });

  String v;
  String code;
  String msg;
  String invNum;
  String invDate;
  String sellerName;
  String invStatus;
  String invPeriod;
  String sellerBan;
  String sellerAddress;
  String invoiceTime;
  String buyerBan;
  String currency;
  List<Details> details;

  factory ScanDetailModel.fromJson(Map<String, dynamic> json) =>
      ScanDetailModel(
        v: json["v"],
        code: json["code"],
        msg: json["msg"],
        invNum: json["invNum"],
        invDate: json["invDate"],
        sellerName: json["sellerName"],
        invStatus: json["invStatus"],
        invPeriod: json["invPeriod"],
        sellerBan: json["sellerBan"],
        sellerAddress: json["sellerAddress"],
        invoiceTime: json["invoiceTime"],
        buyerBan: json["buyerBan"],
        currency: json["currency"],
        details:
            List<Details>.from(json["details"].map((x) => Details.fromJson(x))),
      );
}

class ScanModel {
  ScanModel({
    required this.v,
    required this.code,
    required this.msg,
    required this.invNum,
    required this.invDate,
    required this.sellerName,
    required this.invStatus,
    required this.invPeriod,
    required this.sellerBan,
    required this.sellerAddress,
    required this.invoiceTime,
    required this.buyerBan,
    required this.currency,
  });

  String v;
  String code;
  String msg;
  String invNum;
  String invDate;
  String sellerName;
  String invStatus;
  String invPeriod;
  String sellerBan;
  String sellerAddress;
  String invoiceTime;
  String buyerBan;
  String currency;

  factory ScanModel.fromJson(Map<String, dynamic> json) => ScanModel(
        v: json["v"],
        code: json["code"],
        msg: json["msg"],
        invNum: json["invNum"],
        invDate: json["invDate"],
        sellerName: json["sellerName"],
        invStatus: json["invStatus"],
        invPeriod: json["invPeriod"],
        sellerBan: json["sellerBan"],
        sellerAddress: json["sellerAddress"],
        invoiceTime: json["invoiceTime"],
        buyerBan: json["buyerBan"],
        currency: json["currency"],
      );
}

class Details {
  Details({
    required this.rowNum,
    required this.description,
    required this.quantity,
    required this.unitPrice,
    required this.amount,
  });

  String rowNum;
  String description;
  String quantity;
  String unitPrice;
  String amount;

  factory Details.fromJson(Map<String, dynamic> json) => Details(
        rowNum: json["rowNum"],
        description: json["description"],
        quantity: json["quantity"],
        unitPrice: json["unitPrice"],
        amount: json["amount"],
      );
}
