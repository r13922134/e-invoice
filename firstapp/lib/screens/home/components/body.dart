import 'package:flutter/material.dart';
import '../../../constants.dart';
import 'package:firstapp/screens/details/details_screen.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:firstapp/database/invoice_database.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:firstapp/database/winninglist_database.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firstapp/screens/home/components/interestednews.dart';
import 'package:firstapp/screens/account/components/account_revise.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  _State createState() => _State();
}

var time = DateTime.now();
var date = DateTime(time.year - 1911, time.month);
String current = date.year.toString() + date.month.toString();

class _State extends State<Body> with SingleTickerProviderStateMixin {
  final CategoriesScroller categoriesScroller = const CategoriesScroller();
  ScrollController controller = ScrollController();
  bool closeTopContainer = false;
  double topContainer = 0;

  List<Widget> itemsData = [];

  Future<List<Widget>> getPostsData(String current) async {
    List<Widget> listItems = [];
    List<Header>? relist = await HeaderHelper.instance.getHeader(current);
    List<WinningList> wlist;
    DateTime ldate;
    if (int.parse(current) % 2 == 0) {
      wlist = await WlistHelper.instance.get(current);
      ldate = DateTime(int.parse(current.substring(0, 3)) + 1911,
          int.parse(current.substring(3)) + 1, 25);
    } else {
      wlist =
          await WlistHelper.instance.get((int.parse(current) + 1).toString());
      ldate = DateTime(int.parse(current.substring(0, 3)) + 1911,
          int.parse(current.substring(3)) + 2, 25);
    }
    var diff = ldate.difference(time).inDays + 1;

    if (wlist.isNotEmpty) {
      for (Header h in relist) {
        if (h.invNum.substring(2) == wlist[0].superPrizeNo) {
          await HeaderHelper.instance.update(h, '10000000');
        } else if (h.invNum.substring(2) == wlist[0].spcPrizeNo) {
          await HeaderHelper.instance.update(h, '2000000');
        } else if (h.invNum.substring(2) == wlist[0].firstPrizeNo1 ||
            h.invNum.substring(2) == wlist[0].firstPrizeNo1 ||
            h.invNum.substring(2) == wlist[0].firstPrizeNo1) {
          await HeaderHelper.instance.update(h, '200000');
        } else if (h.invNum.substring(3, 10) ==
                wlist[0].firstPrizeNo1.substring(1, 8) ||
            h.invNum.substring(3, 10) ==
                wlist[0].firstPrizeNo2.substring(1, 8) ||
            h.invNum.substring(3, 10) ==
                wlist[0].firstPrizeNo3.substring(1, 8)) {
          await HeaderHelper.instance.update(h, '40000');
        } else if (h.invNum.substring(4, 10) ==
                wlist[0].firstPrizeNo1.substring(2, 8) ||
            h.invNum.substring(4, 10) ==
                wlist[0].firstPrizeNo2.substring(2, 8) ||
            h.invNum.substring(4, 10) ==
                wlist[0].firstPrizeNo3.substring(2, 8)) {
          await HeaderHelper.instance.update(h, '10000');
        } else if (h.invNum.substring(5, 10) ==
                wlist[0].firstPrizeNo1.substring(3, 8) ||
            h.invNum.substring(5, 10) ==
                wlist[0].firstPrizeNo2.substring(3, 8) ||
            h.invNum.substring(5, 10) ==
                wlist[0].firstPrizeNo3.substring(3, 8)) {
          await HeaderHelper.instance.update(h, '4000');
        } else if (h.invNum.substring(6, 10) ==
                wlist[0].firstPrizeNo1.substring(4, 8) ||
            h.invNum.substring(6, 10) ==
                wlist[0].firstPrizeNo2.substring(4, 8) ||
            h.invNum.substring(6, 10) ==
                wlist[0].firstPrizeNo3.substring(4, 8)) {
          await HeaderHelper.instance.update(h, '1000');
        } else if (h.invNum.substring(7, 10) ==
                wlist[0].firstPrizeNo1.substring(5, 8) ||
            h.invNum.substring(7, 10) ==
                wlist[0].firstPrizeNo2.substring(5, 8) ||
            h.invNum.substring(7, 10) ==
                wlist[0].firstPrizeNo3.substring(5, 8)) {
          await HeaderHelper.instance.update(h, '200');
        }
      }
    }
    List<Header>? responseList = await HeaderHelper.instance.getHeader(current);
    Topbar topList = await HeaderHelper.instance.count(current);
    listItems.add(
      Container(
        height: 95,
        margin: const EdgeInsets.symmetric(horizontal: 26, vertical: 10),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(20.0)),
            color: kPrimaryColor,
            boxShadow: [
              BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 10.0),
            ]),
        child: Padding(
          padding:
              const EdgeInsets.only(top: 12, bottom: 20, left: 25, right: 40),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (wlist.isEmpty)
                      Row(children: const [
                        Icon(CupertinoIcons.money_dollar_circle_fill,
                            color: Color.fromARGB(255, 243, 230, 111),
                            size: 20),
                        Text(
                          " 開獎倒數",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ]),
                    if (wlist.isNotEmpty)
                      Row(children: const [
                        Icon(CupertinoIcons.money_dollar_circle_fill,
                            color: Color.fromARGB(255, 243, 230, 111),
                            size: 20),
                        Text(
                          " 中獎金額",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ]),
                    Row(
                      children: const [
                        Icon(CupertinoIcons.money_dollar,
                            color: Color.fromARGB(255, 250, 240, 154),
                            size: 20),
                        Text(
                          "總消費金額",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (wlist.isNotEmpty)
                      Row(children: [
                        Text(
                          "\$" + topList.winamount.toString() + ' / ',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 23,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '共' + topList.count.toString() + '張  ',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                      ]),
                    if (wlist.isEmpty)
                      Row(children: [
                        Text(
                          diff.toString() + '天 / ',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 19.5,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '共' + topList.count.toString() + '張  ',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                      ]),
                    Text(
                      "\$" + topList.total.toString(),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 21,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                )
              ]),
        ),
      ),
    );
    for (int i = responseList.length - 1; i > -1; i--) {
      listItems.add(
        GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, a, b) => DetailsScreen(
                    tag: responseList[i].tag,
                    invDate: responseList[i].date,
                    seller: responseList[i].seller,
                    address: responseList[i].address,
                    invNum: responseList[i].invNum,
                    time: responseList[i].time,
                    amount: responseList[i].amount,
                    w: responseList[i].w,
                  ),
                ),
              );
            },
            child: Container(
                height: 135,
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                    color: responseList[i].w == 'f'
                        ? Colors.white
                        : const Color.fromARGB(255, 252, 243, 167),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withAlpha(100), blurRadius: 10.0),
                    ]),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  responseList[i].invNum,
                                  style: TextStyle(
                                      color: responseList[i].w == 'f'
                                          ? kTextColor
                                          : const Color.fromARGB(
                                              255, 71, 148, 74),
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '   ' + responseList[i].date + '   ',
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                ),
                                if (responseList[i].barcode == "Scan")
                                  Container(
                                    padding: const EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                      color: Colors.blueGrey,
                                      borderRadius: BorderRadius.circular(7),
                                    ),
                                    child: const Text("紙本",
                                        style: TextStyle(
                                          fontSize: 9,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                        )),
                                  ),
                                if (responseList[i].barcode == "manual")
                                  Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      color: Colors.blueGrey,
                                      borderRadius: BorderRadius.circular(7),
                                    ),
                                    child: const Text("手動",
                                        style: TextStyle(
                                          fontSize: 9,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                        )),
                                  ),
                              ]),
                          Text(
                            responseList[i].seller,
                            style: const TextStyle(
                                fontSize: 11, color: Colors.black),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "\$" + responseList[i].amount,
                            style: const TextStyle(
                                fontSize: 25,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      if (responseList[i].w == 'f')
                        Hero(
                          tag: responseList[i].invNum,
                          child: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                                image: const DecorationImage(
                                    image:
                                        AssetImage("assets/images/image_1.png"),
                                    fit: BoxFit.fill),
                                color: Colors.white,
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(15)),
                          ),
                        ),
                      if (responseList[i].w != "f")
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Hero(
                              tag: responseList[i].invNum,
                              child: Image.asset(
                                "assets/images/money.png",
                                height: 46,
                              ),
                            ),
                            if (responseList[i].w == "500")
                              Container(
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 36, 129, 39),
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                child: const Text("載具伍佰獎",
                                    style: TextStyle(
                                      fontSize: 7.67,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    )),
                              ),
                            if (responseList[i].w == "10000000")
                              Container(
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 36, 129, 39),
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                child: const Text("千萬特別獎",
                                    style: TextStyle(
                                      fontSize: 7.67,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    )),
                              ),
                            if (responseList[i].w == "2000000")
                              Container(
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 36, 129, 39),
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                child: const Text("兩百萬特獎",
                                    style: TextStyle(
                                      fontSize: 7.67,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    )),
                              ),
                            if (responseList[i].w == "200000")
                              Container(
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 36, 129, 39),
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                child: const Text("20萬頭獎",
                                    style: TextStyle(
                                      fontSize: 7.67,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    )),
                              ),
                            if (responseList[i].w == "40000")
                              Container(
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 36, 129, 39),
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                child: const Text("二獎4萬",
                                    style: TextStyle(
                                      fontSize: 7.67,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    )),
                              ),
                            if (responseList[i].w == "10000")
                              Container(
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 36, 129, 39),
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                child: const Text("三獎1萬",
                                    style: TextStyle(
                                      fontSize: 7.67,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    )),
                              ),
                            if (responseList[i].w == "4000")
                              Container(
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 36, 129, 39),
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                child: const Text("四獎4千",
                                    style: TextStyle(
                                      fontSize: 7.67,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    )),
                              ),
                            if (responseList[i].w == "1000")
                              Container(
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 36, 129, 39),
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                child: const Text("五獎1千",
                                    style: TextStyle(
                                      fontSize: 7.67,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    )),
                              ),
                            if (responseList[i].w == "200")
                              Container(
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 36, 129, 39),
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                child: const Text("六獎200",
                                    style: TextStyle(
                                      fontSize: 7.67,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    )),
                              ),
                          ],
                        )
                    ],
                  ),
                ))),
      );
    }

    itemsData = listItems;

    return listItems;
  }

  Future<void> _handleRefresh() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String barcode = pref.getString('barcode') ?? "";
    String password = pref.getString('password') ?? "";
    var client = http.Client();
    var rng = Random();
    var now = DateTime.now();
    int uuid = rng.nextInt(1000);
    int timestamp = DateTime.now().millisecondsSinceEpoch + 30000;
    int exp = timestamp + 50000;
    int m = now.month;

    var formatter = DateFormat('yyyy/MM/dd');
    String sdate;
    String edate;
    DateTime last;
    DateTime start;

    for (int j = 5; j >= 0; j--) {
      uuid = rng.nextInt(1000);
      String term;
      start = DateTime(now.year, now.month - j, 01);
      last = DateTime(start.year, start.month + 1, 0);
      sdate = formatter.format(start);
      edate = formatter.format(last);
      if (start.month < 10) {
        term = (start.year - 1911).toString() + '0' + start.month.toString();
      } else {
        term = (start.year - 1911).toString() + start.month.toString();
      }
      var rbody1 = {
        "version": "0.5",
        "cardType": "3J0002",
        "cardNo": barcode,
        "expTimeStamp": exp.toString().substring(0, 10),
        "action": "carrierInvChk",
        "timeStamp": timestamp.toString().substring(0, 10),
        "startDate": sdate,
        "endDate": edate,
        "onlyWinningInv": 'N',
        "uuid": uuid.toString(),
        "appID": 'EINV0202204156709',
        "cardEncrypt": password,
      };
      var rbody2 = {
        "version": "0.5",
        "cardType": "3J0002",
        "cardNo": barcode,
        "expTimeStamp": exp.toString().substring(0, 10),
        "action": "carrierInvChk",
        "timeStamp": timestamp.toString().substring(0, 10),
        "startDate": sdate,
        "endDate": edate,
        "onlyWinningInv": 'Y',
        "uuid": uuid.toString(),
        "appID": 'EINV0202204156709',
        "cardEncrypt": password,
      };
      var rbody3 = {
        "version": "0.2",
        "action": "QryWinningList",
        "invTerm": term,
        "UUID": uuid.toString(),
        "appID": "EINV0202204156709",
      };
      try {
        var response = await client.post(
            Uri.parse(
                'https://api.einvoice.nat.gov.tw/PB2CAPIVAN/invServ/InvServ'),
            headers: {
              "Content-Type": "application/x-www-form-urlencoded",
            },
            body: rbody1);
        var response2 = await client.post(
            Uri.parse(
                'https://api.einvoice.nat.gov.tw/PB2CAPIVAN/invServ/InvServ'),
            headers: {
              "Content-Type": "application/x-www-form-urlencoded",
            },
            body: rbody2);
        var response3 = await client.post(
            Uri.parse(
                'https://api.einvoice.nat.gov.tw/PB2CAPIVAN/invapp/InvApp'),
            headers: {
              "Content-Type": "application/x-www-form-urlencoded",
            },
            body: rbody3);
        if (response.statusCode == 200 &&
            response2.statusCode == 200 &&
            response3.statusCode == 200) {
          String responseString = response.body;
          String reString = response2.body;
          String winlist = response3.body;
          var w = jsonDecode(winlist);
          var r = jsonDecode(responseString);
          var re = jsonDecode(reString);

          List d = r['details'];
          List d2 = re['details'];

          int tmpyear;
          DateTime invDate;
          String invdate;
          var formatter = DateFormat('yyyy/MM/dd');
          var t;
          if (d.isNotEmpty) {
            for (var de in d) {
              t = de['invDate'];
              tmpyear = t['year'] + 1911;
              invDate = DateTime(tmpyear, t['month'], t['date']);
              invdate = formatter.format(invDate);
              if (await HeaderHelper.instance
                  .checkHeader(de['invNum'], invdate)) {
                await HeaderHelper.instance.add(Header(
                    tag: t['year'].toString() + t['month'].toString(),
                    date: invdate,
                    time: de['invoiceTime'],
                    seller: de['sellerName'],
                    address: de['sellerAddress'],
                    invNum: de['invNum'],
                    barcode: de['cardNo'],
                    amount: de['amount'],
                    w: 'f'));
              }
            }
          }
          if (d2.isNotEmpty) {
            for (var de in d2) {
              t = de['invDate'];
              tmpyear = t['year'] + 1911;
              invDate = DateTime(tmpyear, t['month'], t['date']);
              invdate = formatter.format(invDate);

              await HeaderHelper.instance.deleteold(de['invNum']);
              await HeaderHelper.instance.add(Header(
                  tag: t['year'].toString() + t['month'].toString(),
                  date: invdate,
                  time: de['invoiceTime'],
                  seller: de['sellerName'],
                  address: de['sellerAddress'],
                  invNum: de['invNum'],
                  barcode: de['cardNo'],
                  amount: de['amount'],
                  w: "500"));
            }
          }

          String tmpterm =
              (start.year - 1911).toString() + start.month.toString();
          if (await WlistHelper.instance.checkWlist(tmpterm) &&
              w['code'] == '200') {
            await WlistHelper.instance.add(WinningList(
              tag: tmpterm,
              superPrizeNo: w['superPrizeNo'],
              firstPrizeNo1: w['firstPrizeNo1'],
              firstPrizeNo2: w['firstPrizeNo2'],
              firstPrizeNo3: w['firstPrizeNo3'],
              spcPrizeNo: w['spcPrizeNo'],
            ));
          }
        }
      } catch (e) {
        debugPrint("$e");
      }
    }

    client.close();
  }

  void leftclick() {
    date = DateTime(date.year, date.month - 1);
    setState(() {
      current = date.year.toString() + date.month.toString();

      getPostsData(current);
    });
  }

  void rightclick() {
    date = DateTime(date.year, date.month + 1);
    setState(() {
      current = date.year.toString() + date.month.toString();

      getPostsData(current);
    });
  }

  @override
  void initState() {
    controller.addListener(() {
      double value = controller.offset / 111;

      setState(() {
        topContainer = value;
        closeTopContainer = controller.offset > 320;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double categoryHeight = size.height * 0.25;

    return Scaffold(
      body: FutureBuilder<List<Widget>>(
        future: getPostsData(current),
        builder: (BuildContext context, AsyncSnapshot? snapshot) {
          if (snapshot?.data?.isEmpty ?? true) {
            return SizedBox(
              height: size.height,
              child: Column(
                children: <Widget>[
                  const SizedBox(
                    height: 10,
                  ),
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 500),
                    opacity: closeTopContainer ? 0 : 1,
                    child: AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        width: size.width,
                        alignment: Alignment.topCenter,
                        height: closeTopContainer ? 0 : categoryHeight,
                        child: categoriesScroller),
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextButton(
                          child: const Icon(Icons.arrow_circle_left),
                          onPressed: leftclick,
                        ),
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.blueGrey,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                              '  ' +
                                  date.year.toString() +
                                  '年' +
                                  ' ' +
                                  date.month.toString() +
                                  '月' +
                                  '  ',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              )),
                        ),
                        TextButton(
                          child: const Icon(Icons.arrow_circle_right),
                          onPressed: rightclick,
                        )
                      ]),
                  const SizedBox(height: 10),
                  Expanded(
                    child: LiquidPullToRefresh(
                        height: 90,
                        color: kSecondaryColor,
                        onRefresh: _handleRefresh,
                        child: const Text("\n\n查無發票")),
                  ),
                ],
              ),
            );
          }
          return SizedBox(
            height: size.height,
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 10,
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 350),
                  opacity: closeTopContainer ? 0 : 1,
                  child: AnimatedContainer(
                      duration: const Duration(milliseconds: 350),
                      width: size.width,
                      alignment: Alignment.topCenter,
                      height: closeTopContainer ? 0 : categoryHeight,
                      child: categoriesScroller),
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                        child: const Icon(Icons.arrow_circle_left),
                        onPressed: leftclick,
                      ),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.blueGrey,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                            '  ' +
                                date.year.toString() +
                                '年' +
                                ' ' +
                                date.month.toString() +
                                '月' +
                                '  ',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            )),
                      ),
                      TextButton(
                        child: const Icon(Icons.arrow_circle_right),
                        onPressed: rightclick,
                      )
                    ]),
                const SizedBox(height: 15),
                Expanded(
                    child: LiquidPullToRefresh(
                        height: 90,
                        color: kSecondaryColor,
                        onRefresh: _handleRefresh,
                        child: ListView.builder(
                            controller: controller,
                            itemCount: snapshot?.data.length,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              double scale = 1.0;
                              if (topContainer > 0.5) {
                                scale = index + 0.5 - topContainer;
                                if (scale < 0) {
                                  scale = 0;
                                } else if (scale > 1) {
                                  scale = 1;
                                }
                              }
                              return Opacity(
                                opacity: scale,
                                child: Transform(
                                  transform: Matrix4.identity()
                                    ..scale(scale, scale),
                                  alignment: Alignment.bottomCenter,
                                  child: Align(
                                      heightFactor: 0.7,
                                      alignment: Alignment.topCenter,
                                      child: snapshot?.data[index]),
                                ),
                              );
                            }))),
              ],
            ),
          );
        },
      ),
    );
  }
}
//setUrl();
var resultkeyword = '雲端發票兌獎';
var resulttitle = '雲端發票中獎怎麼領?雲端...';
var resulturl = "https://roo.cash/blog/e-invoice-redeem-guide/";
var resultkeyword2 = '168斷食';
var resulttitle2 = '「168斷食」間歇性斷食不是吃越少瘦越快';
var resulturl2 = "https://event.womenshealth.com.tw/2021/168/";
var resultkeyword3 = '肩頸痠痛';
var resulttitle3 = '7種疾病是你肩頸痠痛的原因!3招還你健...';
var resulturl3 = "https://heho.com.tw/archives/72826";

final Uri _url1 = Uri.parse(resulturl);
final Uri _url2 = Uri.parse(resulturl2);
final Uri _url3 = Uri.parse(resulturl3);


class CategoriesScroller extends StatelessWidget {
  const CategoriesScroller();
  

  @override
  Widget build(BuildContext context) {
    final double categoryHeight =
        MediaQuery.of(context).size.height * 0.30 - 70;
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: FittedBox(
          fit: BoxFit.fill,
          alignment: Alignment.topCenter,
          child: Row(
            children: <Widget>[
              Container(
                width: 150,
                margin: const EdgeInsets.only(right: 20),
                height: categoryHeight,
                decoration: const BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "$resultkeyword",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        onPressed: _launchUrl1,
                        child: Text(
                          "$resulttitle",
                          style: TextStyle(fontSize: 13, color: Colors.white),
                        ),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(kPrimaryColor),
                          side: MaterialStateProperty.all(
                              BorderSide(color: kPrimaryColor, width: 1)),
                          elevation: MaterialStateProperty.all(0),
                        ),
                      ),
                      ElevatedButton(
                        child:  Text(
                          "待處理",
                          style: TextStyle(fontSize: 10, color: Colors.white),
                        ),
                        onPressed: () async {
                            //getselectedkeyword;
                            //final response = await geturl(_selectedkeywordlist[0]);
                            final response = await get2url();
                            resultkeyword = response[0];
                            resulttitle = response[1];
                            resulturl = response[2];
                            final response2 = await get3url();
                            resultkeyword2 = response2[0];
                            resulttitle2 = response2[1];
                            resulturl2 = response2[2];
                            final response3 = await get4url();
                            resultkeyword3 = response3[0];
                            resulttitle3= response3[1];
                            resulturl3 = response3[2];
                            //_url4 = Uri.parse(resulturl);
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(kPrimaryColor),
                          side: MaterialStateProperty.all(
                              BorderSide(color: kPrimaryColor, width: 1)),
                          elevation: MaterialStateProperty.all(0),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: 150,
                margin: const EdgeInsets.only(right: 20),
                height: categoryHeight,
                decoration: const BoxDecoration(
                    color: kSecondaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "$resultkeyword2",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        onPressed: _launchUrl2,
                        child: Text(
                          "$resulttitle2",
                          style: TextStyle(fontSize: 17, color: Colors.white),
                        ),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(kSecondaryColor),
                          side: MaterialStateProperty.all(
                              BorderSide(color: kSecondaryColor, width: 1)),
                          elevation: MaterialStateProperty.all(0),
                        ),
                      ),
                      /*ElevatedButton(
                        onPressed: _launchUrl3,
                        child: const Text(
                          "30+無痛體態維持",
                          style: TextStyle(fontSize: 17, color: Colors.white),
                        ),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(kSecondaryColor),
                          side: MaterialStateProperty.all(
                              BorderSide(color: kSecondaryColor, width: 1)),
                          elevation: MaterialStateProperty.all(0),
                        ),
                      ),*/
                    ],
                  ),
                ),
              ),
              Container(
                width: 150,
                margin: const EdgeInsets.only(right: 20),
                height: categoryHeight,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "$resultkeyword3",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      //Image.asset('assets/images/cancel.png',width: 30,),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        onPressed: _launchUrl3,
                        child:  Text(
                          "$resulttitle3",
                          style: TextStyle(
                              fontSize: 17,
                              color: Color.fromARGB(255, 141, 129, 129)),
                        ),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white),
                          side: MaterialStateProperty.all(
                              BorderSide(color: Colors.white, width: 1)),
                          elevation: MaterialStateProperty.all(0),
                        ),
                      ),
                      /*ElevatedButton(
                        onPressed: _launchUrl6,
                        child: const Text(
                          "16種抗糖尿病明星食物",
                          style: TextStyle(
                              fontSize: 17,
                              color: Color.fromARGB(255, 141, 129, 129)),
                        ),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white),
                          side: MaterialStateProperty.all(
                              BorderSide(color: Colors.white, width: 1)),
                          elevation: MaterialStateProperty.all(0),
                        ),
                      ),*/
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> _launchUrl1() async {
  if (!await launchUrl(_url1)) {
    throw 'Could not launch $_url1';
  }
}

Future<void> _launchUrl2() async {
  if (!await launchUrl(_url2)) {
    throw 'Could not launch $_url2';
  }
}

Future<void> _launchUrl3() async {
  if (!await launchUrl(_url3)) {
    throw 'Could not launch $_url3';
  }
}
