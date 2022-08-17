import 'package:firstapp/database/details_database.dart';
import 'package:firstapp/database/invoice_database.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firstapp/screens/details/detail_model.dart';

class CardInfo {
  CardInfo(
    this.position, {
    required this.name,
    required this.calorie,
    required this.images,
  });
  int position;
  String name;
  String calorie;
  String images;
}

Future<List<CardInfo>> getcurrentdate(String date) async {
  final SharedPreferences pref = await SharedPreferences.getInstance();
  int count = 1;
  String? barcode = pref.getString('barcode') ?? "";
  String? password = pref.getString('password') ?? "";
  List<Header> responseList = [];
  List<invoice_details> response = [];
  List<CardInfo> cards = [];

  responseList = await HeaderHelper.instance.getHeader_date(date);
  for (Header element in responseList) {
    response =
        await DetailHelper.instance.getDetail(element.tag, element.invNum);
    if (response.isEmpty) {
      int timestamp = DateTime.now().millisecondsSinceEpoch + 100;
      int exp = timestamp + 200;
      http.Response _response;
      _response = await http.post(
          Uri.https("api.einvoice.nat.gov.tw", "PB2CAPIVAN/invServ/InvServ"),
          body: {
            "version": "0.5",
            "cardType": "3J0002",
            "cardNo": barcode,
            "expTimeStamp": exp.toString(),
            "action": "carrierInvDetail",
            "timeStamp": timestamp.toString(),
            "invNum": element.invNum,
            "invDate": element.date,
            "uuid": '1000',
            "sellerName": element.seller,
            "amount": element.amount,
            "appID": 'EINV0202204156709',
            "cardEncrypt": password,
          });
      String responseString = _response.body;
      List<Details> tmp = detailModelFromJson(responseString).details;

      for (Details elements in tmp) {
        await DetailHelper.instance.add(invoice_details(
            tag: element.tag,
            invNum: element.invNum,
            name: elements.description,
            date: element.date,
            quantity: elements.quantity,
            amount: elements.amount));
        cards.add(CardInfo(count++,
            name: elements.description,
            calorie: '100',
            images: 'assets/images/eggs.png'));
      }
    } else {
      for (invoice_details value in response) {
        cards.add(CardInfo(count++,
            name: value.name,
            calorie: '100',
            images: 'assets/images/eggs.png'));
      }
    }
  }

  return cards;
}
