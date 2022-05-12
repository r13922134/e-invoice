import 'dart:convert';

DetailModel detailModelFromJson(String str) =>
    DetailModel.fromJson(json.decode(str));

String detailModelToJson(DetailModel data) => json.encode(data.toJson());

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

  Map<String, dynamic> toJson() => {
        "v": v,
        "code": code,
        "msg": msg,
        "invNum": invNum,
        "invDate": invDate,
        "sellerName": sellerName,
        "amount": amount,
        "invStatus": invStatus,
        "invPeriod": invPeriod,
        "details": List<dynamic>.from(details.map((x) => x.toJson())),
        "sellerBan": sellerBan,
        "sellerAddress": sellerAddress,
        "invoiceTime": invoiceTime,
        "currency": currency,
      };
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

  Map<String, dynamic> toJson() => {
        "rowNum": rowNum,
        "description": description,
        "quantity": quantity,
        "unitPrice": unitPrice,
        "amount": amount,
      };
}
