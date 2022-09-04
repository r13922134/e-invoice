import 'package:firstapp/database/details_database.dart';
import 'package:firstapp/database/invoice_database.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'dart:math';

Map<String, String> pic = {
  "主食/食材": 'assets/images/eggs.png',
  "零食 ": 'assets/images/snacks.png',
  "飲料": 'assets/images/drink.png',
  "蔬果": 'assets/images/vegetables.png',
  "麵包": 'assets/images/bread.png',
};
Map<int, String> dict = {
  1: "主食/食材",
  2: "零食 ",
  3: "飲料",
  4: "蔬果",
  5: "保健食品",
  6: "麵包",
  7: "上衣",
  8: "鞋襪",
  9: "美容保養",
  10: "配件",
  11: "奢侈品",
  12: "貼身衣褲",
  13: "個人清潔",
  14: "五金",
  15: "家電",
  16: "家具",
  17: "衛浴",
  18: "收納",
  19: "寢具",
  20: "廚具",
  21: "園藝",
  22: "裝修",
  23: "雜貨",
  24: "汽車用品",
  25: "書本雜誌",
  26: "文具",
  27: "兒童",
  28: "3C",
  29: "體育用品",
  30: "寵物",
  31: "旅遊",
  32: "電玩",
  33: "戶外登山",
  34: "樂器",
  35: "其他"
};

class CardInfo {
  CardInfo(this.position,
      {required this.name,
      required this.calorie,
      this.images,
      required this.invnum,
      required this.type,
      required this.date,
      required this.quantity,
      required this.amount,
      required this.tag});
  int position;
  String name;
  List<String> calorie;
  String? images;
  String invnum;
  int type;
  String tag;
  String date;
  String quantity;
  String amount;
}

class Plist {
  Plist({
    required this.plist,
  });
  List<Ename> plist;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'products': plist,
      };
}

class Ename {
  Ename({
    required this.name,
  });

  String name;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
      };
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
  var client = http.Client();
  for (Header element in responseList) {
    response =
        await DetailHelper.instance.getDetail(element.tag, element.invNum);

    if (response.isEmpty) {
      int timestamp = DateTime.now().millisecondsSinceEpoch + 10000;
      int exp = timestamp + 70000;
      var rng = Random();
      int uuid = rng.nextInt(1000);

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
              "uuid": uuid.toString(),
              "sellerName": element.seller,
              "amount": element.amount,
              "appID": 'EINV0202204156709',
              "cardEncrypt": password,
            });

        if (_response.statusCode == 200) {
          String responseString = _response.body;
          var r = jsonDecode(responseString);
          List d = r['details'];
          for (var de in d) {
            await DetailHelper.instance.add(invoice_details(
                tag: element.toString(),
                invNum: element.toString(),
                name: de['description'],
                date: element.toString(),
                quantity: de['quantity'],
                amount: de['amount']));
            cards.add(CardInfo(count++,
                name: de['description'],
                calorie: [],
                type: 0,
                invnum: element.invNum,
                tag: element.tag,
                date: element.date,
                quantity: de['quantity'],
                amount: de['amount']));
          }
        }
      } catch (e) {
        print("error");
      }
    } else {
      for (invoice_details value in response) {
        cards.add(CardInfo(count++,
            name: value.name,
            calorie: [],
            type: value.type ?? 0,
            invnum: value.invNum,
            tag: value.tag,
            date: value.date,
            quantity: value.quantity,
            amount: value.amount));
      }
    }
  }

  List<Ename> tmparray = [];
  String tmpbody;
  String path1;
  final regex =
      RegExp(r'(\d+(?:\.\d+)?)\s*(kcal|Kcal|cal|大卡|卡|Kilocalorie|kilocalorie)');
  final num = RegExp(r'(\d+(?:\.\d+)?)');
  int index_count = 1;
  List<CardInfo> returncards = [];
  for (CardInfo c in cards) {
    path1 = 'https://www.google.com/search?q=' + c.name + '熱量';
    tmparray = [];
    if (c.type == 0) {
      tmparray.add(Ename(name: c.name));
      Plist p = Plist(plist: tmparray);
      tmpbody = json.encoder.convert(p);
      try {
        var _response2 = await client.post(
            Uri.parse(
                "https://cloudrie-product-classifier.herokuapp.com/product_class"),
            headers: {"Content-Type": "application/json"},
            body: tmpbody);

        if (_response2.statusCode == 200) {
          String responseString2 = _response2.body;
          await AIModelFromJson(responseString2).then((value) async {
            c.type = value.results[0][0];
            if (c.type == 1 ||
                c.type == 2 ||
                c.type == 3 ||
                c.type == 4 ||
                c.type == 6) {
              try {
                List<String> sample = [];
                var re = await http.get(Uri.parse(path1));
                if (re.statusCode == 200) {
                  BeautifulSoup soup1 = BeautifulSoup(re.body);
                  List<Bs4Element> r1 =
                      soup1.findAll("span", class_: "FCUp0c rQMQod");
                  List<Bs4Element> r2 =
                      soup1.findAll("td", class_: "sjsZvd s5aIid OE1use");

                  for (Bs4Element bs4 in r1) {
                    if (regex.hasMatch(bs4.getText())) {
                      sample.add(bs4.getText());
                    } else if (num.hasMatch(bs4.getText())) {
                      sample.add(bs4.getText());
                    }
                  }
                  if (sample.isEmpty) {
                    for (Bs4Element bs4 in r2) {
                      String str = bs4.parent?.getText() ?? "%";
                      if (regex.hasMatch(str) & str.contains(c.name)) {
                        var match = regex.firstMatch(str);
                        str = match?.group(0) ?? '';
                        sample.add(str);
                      } else if (num.hasMatch(str) & str.contains(c.name)) {
                        sample.add(str);
                      }
                    }
                  }

                  c.calorie = sample;
                }
              } catch (e) {
                print("error");
              }
              c.images = pic[dict[c.type] ?? ''] ?? '';
              c.position = index_count++;
              returncards.add(c);
              await DetailHelper.instance.updateType(c, c.type);
            } else {
              await DetailHelper.instance.updateType(c, c.type);
            }
          });
        }
      } catch (e) {
        print("error");
      }
    } else if (c.type == 1 ||
        c.type == 2 ||
        c.type == 3 ||
        c.type == 4 ||
        c.type == 6) {
      try {
        List<String> sample = [];
        var re = await http.get(Uri.parse(path1));
        if (re.statusCode == 200) {
          BeautifulSoup soup1 = BeautifulSoup(re.body);
          List<Bs4Element> r1 = soup1.findAll("span", class_: "FCUp0c rQMQod");
          List<Bs4Element> r2 =
              soup1.findAll("td", class_: "sjsZvd s5aIid OE1use");

          for (Bs4Element bs4 in r1) {
            if (regex.hasMatch(bs4.getText())) {
              sample.add(bs4.getText());
            } else if (num.hasMatch(bs4.getText())) {
              sample.add(bs4.getText());
            }
          }
          if (sample.isEmpty) {
            for (Bs4Element bs4 in r2) {
              String str = bs4.parent?.getText() ?? "%";
              if (regex.hasMatch(str) & str.contains(c.name)) {
                var match = regex.firstMatch(str);
                str = match?.group(0) ?? '';
                sample.add(str);
              } else if (num.hasMatch(str) & str.contains(c.name)) {
                sample.add(str);
              }
            }
          }

          c.calorie = sample;
        }
      } catch (e) {
        print("error");
      }
      c.images = pic[dict[c.type] ?? ''] ?? '';
      c.position = index_count++;

      returncards.add(c);
    }
  }
  client.close();

  return returncards;
}

Future<AIModel> AIModelFromJson(String str) async {
  return AIModel.fromJson(json.decode(str));
}

class AIModel {
  AIModel({
    required this.results,
    required this.version,
  });

  int version;
  List<List<int>> results;

  factory AIModel.fromJson(Map<String, dynamic> json) => AIModel(
        results: List<List<int>>.from(
            json["results"].map((x) => List<int>.from(x.map((x) => x)))),
        version: json["version"],
      );
}
