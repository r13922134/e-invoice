import 'package:flutter/material.dart';
import '../../../constants.dart';
import 'package:firstapp/screens/details/details_screen.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:firstapp/database/invoice_database.dart';

main() {
  WidgetsFlutterBinding.ensureInitialized();
}

class Body extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<Body> {
  final CategoriesScroller categoriesScroller = CategoriesScroller();
  ScrollController controller = ScrollController();
  bool closeTopContainer = false;
  double topContainer = 0;

  List<Widget> itemsData = [];

  Future getPostsData() async {
    List<Header> responseList = await HeaderHelper.instance.getHeader();
    List<Widget> listItems = [];
    for (int i = responseList.length - 1; i > -1; i--) {
      listItems.add(
        GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailsScreen(
                    tag: responseList[i].tag,
                    seller: responseList[i].seller,
                    address: responseList[i].address,
                    invNum: responseList[i].inv_num,
                    amount: responseList[i].amount,
                  ),
                ),
              );
            },
            child: Container(
                height: 150,
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    color: Colors.white,
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
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  responseList[i].inv_num,
                                  style: const TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  ' ' + responseList[i].date,
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                ),
                              ]),
                          Text(
                            responseList[i].seller,
                            style: const TextStyle(
                                fontSize: 11, color: Colors.black),
                          ),
                          SizedBox(
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
                      Image.asset(
                        "assets/images/image_1.png",
                        height: 80,
                      )
                    ],
                  ),
                ))),
      );
    }
    ;
    setState(() {
      itemsData = listItems;
    });
  }

  @override
  void initState() {
    super.initState();
    getPostsData();
    controller.addListener(() {
      double value = controller.offset / 119;

      setState(() {
        topContainer = value;
        closeTopContainer = controller.offset > 50;
      });
    });
  }

  Future<void> _handleRefresh() async {
    return await Future.delayed(Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double categoryHeight = size.height * 0.30;
    return SafeArea(
      child: Scaffold(
        body: FutureBuilder(
          future: getPostsData(),
          builder: (BuildContext context, snapshot) {
            return Container(
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
                  Expanded(
                    child: LiquidPullToRefresh(
                        height: 90,
                        color: kSecondaryColor,
                        onRefresh: _handleRefresh,
                        child: ListView.builder(
                            controller: controller,
                            itemCount: itemsData.length,
                            physics: BouncingScrollPhysics(),
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
                                      child: itemsData[index]),
                                ),
                              );
                            })),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class CategoriesScroller extends StatelessWidget {
  const CategoriesScroller();

  @override
  Widget build(BuildContext context) {
    final double categoryHeight =
        MediaQuery.of(context).size.height * 0.30 - 50;
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
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
                margin: EdgeInsets.only(right: 20),
                height: categoryHeight,
                decoration: BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Most\nFavorites",
                        style: TextStyle(
                            fontSize: 25,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "20 Items",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: 150,
                margin: EdgeInsets.only(right: 20),
                height: categoryHeight,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Newest",
                          style: TextStyle(
                              fontSize: 25,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "20 Items",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                width: 150,
                margin: EdgeInsets.only(right: 20),
                height: categoryHeight,
                decoration: BoxDecoration(
                    color: kSecondaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Super\nSaving",
                        style: TextStyle(
                            fontSize: 25,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "20 Items",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
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
