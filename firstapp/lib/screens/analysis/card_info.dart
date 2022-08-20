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
  int i = 0;
  responseList = await HeaderHelper.instance.getHeader_date(date);
  for (Header element in responseList) {
    response =
        await DetailHelper.instance.getDetail(element.tag, element.invNum);

    if (response.isEmpty) {
      int timestamp = DateTime.now().millisecondsSinceEpoch + 100000;
      int exp = timestamp + 10000000;
      int len = barcode.length;
      String uuid = barcode.substring(1, len);
      var client = http.Client();

      try {
        var _response = await client.post(
            Uri.https("api.einvoice.nat.gov.tw", "PB2CAPIVAN/invServ/InvServ"),
            body: {
              "version": "0.5",
              "cardType": "3J0002",
              "cardNo": barcode,
              "expTimeStamp": exp.toString().substring(0, 10),
              "action": "carrierInvDetail",
              "timeStamp": timestamp.toString().substring(0, 10),
              "invNum": element.invNum,
              "invDate": element.date,
              "uuid": uuid,
              "sellerName": element.seller,
              "amount": element.amount,
              "appID": 'EINV0202204156709',
              "cardEncrypt": password,
            });

        String responseString = _response.body;
        if (responseString != '') {
          await detailModelFromJson(responseString).then((value) {
            for (Details elements in value.details) {
              DetailHelper.instance.add(invoice_details(
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
          });
        }
      } catch (e) {
        print("error");
      } finally {
        client.close();
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
