import 'package:flutter/material.dart';
import 'package:firstapp/screens/analysis/card_info.dart';
import 'package:firstapp/constants.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:http/http.dart' as http;
import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:url_launcher/url_launcher.dart';

class Linkstr {
  Linkstr({
    required this.title,
    required this.link,
  });
  String title;
  String link;
}

class DetailPage extends StatelessWidget {
  final CardInfo cardInfo;
  final index;

  const DetailPage({Key? key, required this.cardInfo, required this.index})
      : super(key: key);
  Future link(String link) async {
    if (!await launchUrl(Uri.parse(link))) {
      throw 'Could not launch $link';
    }
  }

  Future<List<Linkstr>> getnews(String str) async {
    var client = http.Client();
    List<Linkstr> tlist = [];
    String path = 'https://www.google.com/search?q=' + str + ' 熱量&tbm=nws';
    String path2 = 'https://www.google.com/search?q=' + str + ' &tbm=nws';

    try {
      var re = await http.get(Uri.parse(path));

      if (re.statusCode == 200) {
        BeautifulSoup soup = BeautifulSoup(re.body);
        String tmp;
        List<Bs4Element> r1 =
            soup.findAll('div', class_: 'Gx5Zad fP1Qef xpd EtOod pkphOe');
        for (Bs4Element b in r1) {
          tmp = b.find('a')?.getAttrValue('href') ?? '';
          tmp = tmp.substring(7);
          String searchString = '&sa';
          int index = tmp.indexOf(searchString);
          tmp = tmp.substring(0, index);
          tlist.add(Linkstr(title: b.getText(), link: tmp));
        }
      }
      if (tlist.isEmpty) {
        re = await http.get(Uri.parse(path2));

        if (re.statusCode == 200) {
          BeautifulSoup soup = BeautifulSoup(re.body);
          String tmp;
          List<Bs4Element> r1 =
              soup.findAll('div', class_: 'Gx5Zad fP1Qef xpd EtOod pkphOe');
          for (Bs4Element b in r1) {
            tmp = b.find('a')?.getAttrValue('href') ?? '';
            tmp = tmp.substring(7);
            String searchString = '&sa';
            int index = tmp.indexOf(searchString);
            tmp = tmp.substring(0, index);
            tlist.add(Linkstr(title: b.getText(), link: tmp));
          }
        }
      }
    } catch (e) {
      print("error");
    }
    client.close();

    return tlist;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const SizedBox(height: 300),
                        Text(
                          cardInfo.name,
                          style: const TextStyle(
                            fontFamily: 'Avenir',
                            fontSize: 40,
                            color: kTextColor,
                            fontWeight: FontWeight.w900,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          cardInfo.calorie + ' kcal',
                          style: const TextStyle(
                            fontFamily: 'Avenir',
                            fontSize: 31,
                            color: kTextColor,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        const Divider(color: Color.fromARGB(255, 226, 192, 68)),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 32.0),
                    child: Text(
                      '相關資訊',
                      style: TextStyle(
                        fontFamily: 'Avenir',
                        fontSize: 25,
                        color: Color(0xff47455f),
                        fontWeight: FontWeight.w300,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  const SizedBox(height: 30),
                  FutureBuilder<List<Linkstr>>(
                      future: getnews(cardInfo.name),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          List<Color> colors = [
                            const Color.fromARGB(255, 57, 62, 65),
                            const Color.fromARGB(255, 226, 192, 68),
                            const Color.fromARGB(255, 209, 73, 79),
                            const Color.fromARGB(255, 211, 208, 203),
                          ];
                          return Container(
                            height: 190,
                            padding: const EdgeInsets.only(left: 32.0),
                            child: ListView.builder(
                                itemCount: snapshot.data.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return Container(
                                    width: 150,
                                    margin: const EdgeInsets.only(right: 20),
                                    decoration: BoxDecoration(
                                        color: colors[index % 4],
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(20.0))),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          const SizedBox(
                                            height: 50,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              link(snapshot.data[index].link);
                                            },
                                            child: Text(
                                              snapshot.data[index].title
                                                      .substring(0, 16) +
                                                  '...',
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  color: kBackgroundColor,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                          );
                        } else {
                          return SizedBox(
                              height: 200,
                              child: Center(
                                  child: LoadingAnimationWidget.flickr(
                                rightDotColor:
                                    const Color.fromARGB(255, 57, 62, 65),
                                leftDotColor:
                                    const Color.fromARGB(255, 226, 192, 68),
                                size: 50,
                              )));
                        }
                      }),
                  const SizedBox(height: 80)
                ],
              ),
            ),
            Positioned(
              top: 10,
              right: -30,
              child: Hero(
                  tag: index,
                  child: Image.asset(cardInfo.images ?? '', width: 270)),
            ),
            Positioned(
              top: 60,
              left: 32,
              child: Text(
                cardInfo.position.toString(),
                style: TextStyle(
                  fontFamily: 'Avenir',
                  fontSize: 247,
                  color: kTextColor.withOpacity(0.08),
                  fontWeight: FontWeight.w900,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_back_ios, size: 30),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
