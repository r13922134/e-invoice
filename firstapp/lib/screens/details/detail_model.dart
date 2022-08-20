import 'dart:convert';

Future<DetailModel> detailModelFromJson(String str) async {
  return DetailModel.fromJson(json.decode(str));
}

class DetailModel {
  DetailModel({
    required this.v,
    required this.code,
    required this.msg,
    required this.invNum,
    required this.invDate,
    required this.sellerName,
    required this.amount,
    required this.invStatus,
    required this.invPeriod,
    required this.details,
    required this.sellerBan,
    required this.sellerAddress,
    required this.invoiceTime,
    required this.currency,
  });

  String v;
  int code;
  String msg;
  String invNum;
  String invDate;
  String sellerName;
  String amount;
  String invStatus;
  String invPeriod;
  List<Details> details;
  String sellerBan;
  String sellerAddress;
  String invoiceTime;
  String currency;

  factory DetailModel.fromJson(Map<String, dynamic> json) => DetailModel(
        v: json["v"],
        code: json["code"],
        msg: json["msg"],
        invNum: json["invNum"],
        invDate: json["invDate"],
        sellerName: json["sellerName"],
        amount: json["amount"],
        invStatus: json["invStatus"],
        invPeriod: json["invPeriod"],
        details:
            List<Details>.from(json["details"].map((x) => Details.fromJson(x))),
        sellerBan: json["sellerBan"],
        sellerAddress: json["sellerAddress"],
        invoiceTime: json["invoiceTime"],
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
