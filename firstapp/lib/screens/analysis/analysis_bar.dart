import 'dart:async';
import 'dart:math';
import 'package:firstapp/constants.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:firstapp/database/details_database.dart';
import 'package:firstapp/database/invoice_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

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

class AnalysisBar extends StatefulWidget {
  final List<Color> availableColors = const [
    Colors.purpleAccent,
    Colors.yellow,
    Colors.lightBlue,
    Colors.orange,
    Colors.pink,
    Colors.redAccent,
  ];

  const AnalysisBar({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => BarChartSample1State();
}

var time = DateTime.now();
var date = DateTime(time.year - 1911, time.month);
String current = date.year.toString() + date.month.toString();

class BarChartSample1State extends State<AnalysisBar> {
  final Color barBackgroundColor = const Color(0xff72d8bf);
  final Duration animDuration = const Duration(milliseconds: 250);
  int touchedIndex = -1;
  bool isPlaying = false;
  double food = 0, clothe = 0, items = 0, tech = 0, other = 0;

  Future<void> classify(String current) async {
    food = 0;
    clothe = 0;
    items = 0;
    tech = 0;
    other = 0;
    List<invoice_details> responseList = [];
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String barcode = pref.getString('barcode') ?? "";
    String password = pref.getString('password') ?? "";
    List<Header>? relist = await HeaderHelper.instance.getHeader(current);
    List<Bardata> l = await DetailHelper.instance.getmonth(current);
    var client = http.Client();
    int timestamp = DateTime.now().millisecondsSinceEpoch + 40000;
    int exp = timestamp + 65000;

    for (int i = 0; i < relist.length; i++) {
      timestamp += 5000;
      exp += 5000;
      responseList = await DetailHelper.instance
          .getDetail(relist[i].tag, relist[i].invNum);
      if (responseList.isEmpty) {
        var rbody = {
          "version": "0.5",
          "cardType": "3J0002",
          "cardNo": barcode,
          "expTimeStamp": exp.toString().substring(0, 10),
          "action": "carrierInvDetail",
          "timeStamp": timestamp.toString().substring(0, 10),
          "invNum": relist[i].invNum,
          "invDate": relist[i].date,
          "uuid": '1000',
          "appID": 'EINV0202204156709',
          "cardEncrypt": password,
        };
        try {
          var response = await client.post(
            Uri.parse(
                "https://api.einvoice.nat.gov.tw/PB2CAPIVAN/invServ/InvServ"),
            body: rbody,
          );
          if (response.statusCode == 200) {
            String responseString = response.body;
            var r = jsonDecode(responseString);
            List d = r['details'];
            for (var de in d) {
              l.add(Bardata(name: de['description'], price: de['amount']));
            }
          }
        } catch (e) {
          debugPrint("$e");
        }
      } else {
        for (invoice_details ind in responseList) {
          l.add(Bardata(name: ind.name, price: ind.amount));
        }
      }
    }
    List<Ename> tmparray = [];

    for (Bardata s in l) {
      tmparray.add(Ename(name: s.name));
    }
    Plist p = Plist(plist: tmparray);
    String tmpbody = json.encoder.convert(p);
    try {
      var _response2 = await client.post(
          Uri.parse(
              "https://cloudrie-product-classifier.herokuapp.com/product_class"),
          headers: {"Content-Type": "application/json"},
          body: tmpbody);

      if (_response2.statusCode == 200) {
        String responseString2 = _response2.body;
        var r = jsonDecode(responseString2);
        List result = r['results'];
        for (int i = 0; i < result.length; i++) {
          if (int.parse(l[i].price) > 0) {
            if (result[i][0] == 1 ||
                result[i][0] == 2 ||
                result[i][0] == 3 ||
                result[i][0] == 4 ||
                result[i][0] == 4) {
              food += int.parse(l[i].price);
            } else if (result[i][0] == 7 ||
                result[i][0] == 8 ||
                result[i][0] == 10 ||
                result[i][0] == 12) {
              clothe += int.parse(l[i].price);
            } else if (result[i][0] == 9 ||
                result[i][0] == 13 ||
                result[i][0] == 14 ||
                result[i][0] == 16 ||
                result[i][0] == 17 ||
                result[i][0] == 18 ||
                result[i][0] == 19 ||
                result[i][0] == 20 ||
                result[i][0] == 22 ||
                result[i][0] == 23 ||
                result[i][0] == 24 ||
                result[i][0] == 25 ||
                result[i][0] == 26 ||
                result[i][0] == 29) {
              items += int.parse(l[i].price);
            } else if (result[i][0] == 28 ||
                result[i][0] == 32 ||
                result[i][0] == 15) {
              tech += int.parse(l[i].price);
            } else {
              other += int.parse(l[i].price);
            }
          }
        }
      }
    } catch (e) {
      print("error");
    }
    client.close();
  }

  void leftclick() {
    date = DateTime(date.year, date.month - 1);
    setState(() {
      current = date.year.toString() + date.month.toString();
    });
    classify(current);
  }

  void rightclick() {
    date = DateTime(date.year, date.month + 1);
    setState(() {
      current = date.year.toString() + date.month.toString();
    });
    classify(current);
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Neumorphic(
        style: NeumorphicStyle(
            shape: NeumorphicShape.concave,
            intensity: 0.9,
            boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(25)),
            depth: 10,
            lightSource: LightSource.topRight,
            color: Color.fromARGB(255, 211, 217, 221)),
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Row(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.bar_chart,
                            color: Color.fromARGB(255, 255, 245, 155)),
                        Text(
                          ' 消費分析',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Color.fromARGB(255, 59, 110, 110),
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ]),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          child: const Icon(
                            Icons.arrow_circle_left,
                            color: kBackgroundColor,
                          ),
                          onPressed: leftclick,
                        ),
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: kBackgroundColor,
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
                                fontSize: 13,
                                color: Color.fromARGB(255, 59, 110, 110),
                                fontWeight: FontWeight.w700,
                              )),
                        ),
                        TextButton(
                          child: const Icon(Icons.arrow_circle_right,
                              color: kBackgroundColor),
                          onPressed: rightclick,
                        )
                      ]),
                  const SizedBox(
                    height: 38,
                  ),
                  Expanded(
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: FutureBuilder(
                            future: classify(current),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                return BarChart(
                                  mainBarData(),
                                  swapAnimationDuration: animDuration,
                                );
                              }
                              return SizedBox(
                                  height: 10,
                                  child: Center(
                                      child: LoadingAnimationWidget.inkDrop(
                                    color: Color.fromARGB(255, 255, 245, 155),
                                    size: 60,
                                  )));
                            })),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                ],
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Align(
            //     alignment: Alignment.topRight,
            //     child: IconButton(
            //       icon: Icon(
            //         isPlaying ? Icons.pause : Icons.play_arrow,
            //         color: Colors.blueGrey,
            //       ),
            //       onPressed: () {
            //         setState(() {
            //           isPlaying = !isPlaying;
            //           if (isPlaying) {
            //             refreshState();
            //           }
            //         });
            //       },
            //     ),
            //   ),
            // )
          ],
        ),
      ),
    );
  }

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    Color barColor = kPrimaryColor,
    double width = 22,
    List<int> showTooltips = const [],
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: isTouched ? y + 1 : y,
          color: Color.fromARGB(255, 255, 245, 155),
          width: width,
          borderSide: const BorderSide(
              color: Color.fromARGB(255, 240, 234, 181), width: 1),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 20,
            color: const Color.fromARGB(255, 230, 239, 241),
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  List<BarChartGroupData> showingGroups() => List.generate(5, (i) {
        switch (i) {
          case 0:
            return makeGroupData(0, 100, isTouched: i == touchedIndex);
          case 1:
            return makeGroupData(1, clothe, isTouched: i == touchedIndex);
          case 2:
            return makeGroupData(2, items, isTouched: i == touchedIndex);
          case 3:
            return makeGroupData(3, tech, isTouched: i == touchedIndex);
          case 4:
            return makeGroupData(4, other, isTouched: i == touchedIndex);
          default:
            return throw Error();
        }
      });

  BarChartData mainBarData() {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.blueGrey,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              String weekDay;
              switch (group.x.toInt()) {
                case 0:
                  weekDay = '飲食';
                  break;
                case 1:
                  weekDay = '衣物配件';
                  break;
                case 2:
                  weekDay = '日用品';
                  break;
                case 3:
                  weekDay = '3C家電';
                  break;
                case 4:
                  weekDay = '其他';
                  break;

                default:
                  throw Error();
              }
              return BarTooltipItem(
                weekDay + '\n',
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: (rod.toY).toString(),
                    style: const TextStyle(
                      color: Colors.yellow,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              );
            }),
        touchCallback: (FlTouchEvent event, barTouchResponse) {
          // setState(() {
          //   if (!event.isInterestedForInteractions ||
          //       barTouchResponse == null ||
          //       barTouchResponse.spot == null) {
          //     touchedIndex = -1;
          //     return;
          //   }
          //   touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
          // });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: getTitles,
            reservedSize: 38,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(),
      gridData: FlGridData(show: false),
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color.fromARGB(255, 59, 110, 110),
      fontWeight: FontWeight.bold,
      fontSize: 13,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('飲食', style: style);
        break;
      case 1:
        text = const Text('衣物配件', style: style);
        break;
      case 2:
        text = const Text('日用品', style: style);
        break;
      case 3:
        text = const Text('3C家電', style: style);
        break;
      case 4:
        text = const Text('其他', style: style);
        break;

      default:
        text = const Text('', style: style);
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16,
      child: text,
    );
  }

  BarChartData randomData() {
    return BarChartData(
      barTouchData: BarTouchData(
        enabled: false,
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: getTitles,
            reservedSize: 38,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: List.generate(5, (i) {
        switch (i) {
          case 0:
            return makeGroupData(0, Random().nextInt(15).toDouble() + 6,
                barColor: widget.availableColors[
                    Random().nextInt(widget.availableColors.length)]);
          case 1:
            return makeGroupData(1, Random().nextInt(15).toDouble() + 6,
                barColor: widget.availableColors[
                    Random().nextInt(widget.availableColors.length)]);
          case 2:
            return makeGroupData(2, Random().nextInt(15).toDouble() + 6,
                barColor: widget.availableColors[
                    Random().nextInt(widget.availableColors.length)]);
          case 3:
            return makeGroupData(3, Random().nextInt(15).toDouble() + 6,
                barColor: widget.availableColors[
                    Random().nextInt(widget.availableColors.length)]);
          case 4:
            return makeGroupData(4, Random().nextInt(15).toDouble() + 6,
                barColor: widget.availableColors[
                    Random().nextInt(widget.availableColors.length)]);

          default:
            return throw Error();
        }
      }),
      gridData: FlGridData(show: false),
    );
  }

  Future<dynamic> refreshState() async {
    setState(() {});
    await Future<dynamic>.delayed(
        animDuration + const Duration(milliseconds: 50));
    if (isPlaying) {
      await refreshState();
    }
  }
}
