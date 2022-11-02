import 'profile_menu.dart';
import 'profile_pic.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:firstapp/screens/account/components/account_revise.dart';
import 'package:firstapp/screens/login/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cool_alert/cool_alert.dart';
import '../../../constants.dart';
import 'package:firstapp/database/invoice_database.dart';
import 'package:firstapp/database/details_database.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class Carrier {
  Carrier({
    required this.name,
    required this.type,
  });
  String name;
  String type;

  factory Carrier.fromJson(Map<String, dynamic> jsonData) {
    return Carrier(
      name: jsonData['name'],
      type: jsonData['type'],
    );
  }

  static Map<String, dynamic> toMap(Carrier carrier) => {
        'name': carrier.name,
        'type': carrier.type,
      };
  static String encode(List<Carrier> carriers) => json.encode(
        carriers
            .map<Map<String, dynamic>>((carrier) => Carrier.toMap(carrier))
            .toList(),
      );

  static List<Carrier> decode(String carriers) =>
      (json.decode(carriers) as List<dynamic>)
          .map<Carrier>((item) => Carrier.fromJson(item))
          .toList();
}

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  ProfileBody createState() => ProfileBody();
}

class ProfileBody extends State<Body> {
  List<String> pic = [
    "assets/images/credit_card.png",
    "assets/images/bank.jpg",
    "assets/images/icash.jpg",
    "assets/images/ipass.png",
    "assets/images/easy_card.png",
    "assets/images/carrier.png",
  ];
  Future<String> getBarcode() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String barcode = pref.getString('barcode') ?? 'null';

    return barcode;
  }

  Future link(String link) async {
    if (!await launchUrl(Uri.parse(link))) {
      throw 'Could not launch $link';
    }
  }

  Future<List<Carrier>> getcard() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String barcode = pref.getString('barcode') ?? 'null';
    String password = pref.getString('password') ?? 'null';
    String serial = pref.getString('serial') ?? '0000000001';
    int timestamp = DateTime.now().millisecondsSinceEpoch + 20000;
    String stamp = timestamp.toString().substring(0, 10);
    var client = http.Client();
    String str = 'action=qryCarrierAgg&appID=EINV0202204156709&cardEncrypt=' +
        password +
        '&cardNo=' +
        barcode +
        '&cardType=3J0002&serial=' +
        serial +
        '&timeStamp=' +
        stamp +
        '&uuid=' +
        password +
        '&version=1.0';
    var key = utf8.encode('T054NzZ6RzQ5bXRpdVdJOQ==');
    List<int> messageBytes = utf8.encode(str);
    Hmac hmac = new Hmac(sha256, key);
    Digest result = hmac.convert(messageBytes);
    String signature = base64UrlEncode(result.bytes);
    var rbody = {
      "version": "1.0",
      "serial": serial,
      "action": "qryCarrierAgg",
      "cardType": "3J0002",
      "cardNo": barcode,
      "cardEncrypt": password,
      "appID": 'EINV0202204156709',
      "timeStamp": stamp,
      "uuid": password,
      "signature": signature,
    };
    List<Carrier> c = [];
    try {
      var response = await client.post(
          Uri.parse(
              'https://api.einvoice.nat.gov.tw/PB2CAPIVAN/Carrier/Aggregate'),
          headers: {
            "Content-Type": "application/x-www-form-urlencoded",
          },
          body: rbody);
      if (response.statusCode == 200) {
        String responseString = response.body;
        var r = jsonDecode(responseString);
        if (r['code'] == 200) {
          List d = r['carriers'];
          String t = '';
          for (var de in d) {
            if (de['carrierType'] == 'EK0002') {
              t = pic[0];
            } else if (de['carrierType'] == 'BK0001') {
              t = pic[1];
            } else if (de['carrierType'] == '2G0001') {
              t = pic[2];
            } else if (de['carrierType'] == '1H0001') {
              t = pic[3];
            } else if (de['carrierType'] == '1K0001') {
              t = pic[4];
            } else {
              t = pic[5];
            }
            c.add(Carrier(name: de['carrierName'], type: t));
            String encodedData = Carrier.encode(c);
            pref.setString('CarrierList', encodedData);
          }
        } else {
          String clist = pref.getString('CarrierList') ?? '';
          if (clist != '') {
            c = Carrier.decode(clist);
          }
        }
      }
    } catch (e) {
      debugPrint("$e");
      String clist = pref.getString('CarrierList') ?? '';

      if (clist != '') {
        c = Carrier.decode(clist);
      }
    }

    client.close();

    c.add(Carrier(name: '+', type: '+'));
    pref.setString(
        'serial', (int.parse(serial) + 1).toString().padLeft(10, '0'));
    return c;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          const SizedBox(height: 20),
          const ProfilePic(),
          const SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.all(18),
            child: Container(
              height: 50,
              width: 350,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                  color: const Color(0xFFF5F6F9)),
              child: Row(
                children: [
                  const Icon(
                    Icons.perm_device_info,
                    color: kPrimaryColor,
                  ),
                  Expanded(
                      child: Text('已歸戶載具',
                          style: TextStyle(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.w600))),
                ],
              ),
            ),
          ),
          SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: FittedBox(
                      fit: BoxFit.fill,
                      alignment: Alignment.topCenter,
                      child: Row(children: <Widget>[
                        Container(
                            height: 80.0,
                            child: FutureBuilder<List<Carrier>>(
                                future: getcard(),
                                builder: (BuildContext context,
                                    AsyncSnapshot snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    List<Color> colors = [
                                      kPrimaryColor,
                                      Color.fromARGB(255, 158, 118, 130),
                                      Color.fromARGB(255, 96, 87, 112),
                                    ];
                                    return ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: snapshot.data.length,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          width: 120,
                                          height: 40,
                                          margin:
                                              const EdgeInsets.only(right: 20),
                                          child: Neumorphic(
                                            padding: EdgeInsets.all(8),
                                            style: NeumorphicStyle(
                                                intensity: 0.9,
                                                surfaceIntensity: 0.9,
                                                boxShape: NeumorphicBoxShape
                                                    .roundRect(
                                                        BorderRadius.circular(
                                                            12)),
                                                depth: 12,
                                                lightSource:
                                                    LightSource.topRight,
                                                color: colors[index % 3]),
                                            child: Stack(
                                              children: <Widget>[
                                                if (index !=
                                                    snapshot.data.length - 1)
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Container(
                                                        height: 15,
                                                        width: 10,
                                                        decoration:
                                                            BoxDecoration(
                                                          image: const DecorationImage(
                                                              image: AssetImage(
                                                                  "assets/images/contact_less.png"),
                                                              fit: BoxFit.fill),
                                                        ),
                                                      ),
                                                      Container(
                                                        height: 25,
                                                        width: 25,
                                                        decoration:
                                                            BoxDecoration(
                                                          image: DecorationImage(
                                                              image: AssetImage(
                                                                  snapshot
                                                                      .data[
                                                                          index]
                                                                      .type),
                                                              fit: BoxFit.fill),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                if (index ==
                                                    snapshot.data.length - 1)
                                                  Positioned(
                                                    top: 5,
                                                    right: 28,
                                                    child: ZoomTapAnimation(
                                                      end: 0.53,
                                                      onTap: () {
                                                        link(
                                                            'https://www.einvoice.nat.gov.tw/APCONSUMER/BTC504W/');
                                                      },
                                                      child: Icon(
                                                        Icons.add,
                                                        size: 50,
                                                        color: kBackgroundColor,
                                                      ),
                                                    ),
                                                  ),
                                                if (index !=
                                                    snapshot.data.length - 1)
                                                  Center(
                                                    child: Text(
                                                      snapshot.data[index].name
                                                                  .length >
                                                              13
                                                          ? snapshot.data[index]
                                                                  .name
                                                                  .substring(
                                                                      0, 11) +
                                                              '..'
                                                          : snapshot
                                                              .data[index].name,
                                                      style: TextStyle(
                                                          fontSize: 9,
                                                          color:
                                                              kBackgroundColor,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  } else {
                                    return SizedBox(
                                        height: 200,
                                        child: Center(
                                            child:
                                                LoadingAnimationWidget.flickr(
                                          rightDotColor: kSecondaryColor,
                                          leftDotColor: kPrimaryColor,
                                          size: 50,
                                        )));
                                  }
                                }))
                      ])))),
          const SizedBox(height: 10),
          ProfileMenu(
            text: "基本資料",
            icon: "assets/icons/User Icon.svg",
            press: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AccountRevise(),
                ),
              ),
            },
          ),
          ProfileMenu(
            text: "手機條碼申請",
            icon: "assets/icons/Question mark.svg",
            press: () {
              link('https://www.einvoice.nat.gov.tw/APCONSUMER/BTC501W/');
            },
          ),
          FutureBuilder<String>(
              future: getBarcode(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.data == 'null') {
                    return ProfileMenu(
                      text: "登入",
                      icon: "assets/icons/Log in.svg",
                      press: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        ),
                      },
                    );
                  } else {
                    return ProfileMenu(
                        text: "登出",
                        icon: "assets/icons/Log out.svg",
                        press: () => {
                              CoolAlert.show(
                                context: context,
                                type: CoolAlertType.confirm,
                                confirmBtnColor: kPrimaryColor,
                                onConfirmBtnTap: () async {
                                  await HeaderHelper.instance.delete();
                                  await DetailHelper.instance.delete();
                                  SharedPreferences pref =
                                      await SharedPreferences.getInstance();
                                  await pref.clear();
                                  setState(() {});
                                  showTopSnackBar(
                                    context,
                                    const CustomSnackBar.success(
                                      message: "登出成功",
                                      backgroundColor: kSecondaryColor,
                                    ),
                                  );
                                  Navigator.pop(context);
                                },
                                text: "登出確認",
                              )
                            });
                  }
                } else {
                  return const CircularProgressIndicator();
                }
              })
        ],
      ),
    );
  }
}
