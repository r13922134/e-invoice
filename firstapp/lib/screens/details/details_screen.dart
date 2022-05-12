import 'package:firstapp/constants.dart';
import 'package:flutter/material.dart';
import 'package:firstapp/database/details_database.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({
    Key? key,
    required this.tag,
    required this.seller,
    required this.address,
    required this.invNum,
    required this.amount,
  }) : super(key: key);

  final String tag, invNum, seller, address, amount;
  @override
  _InvoiceDetail createState() => _InvoiceDetail();
}

class _InvoiceDetail extends State<DetailsScreen> {
  List<invoice_details> responseList = [];
  bool _slowAnimations = false;
  List<Widget> listItems = [];

  Future<List<Widget>> getDetail() async {
    responseList =
        await DetailHelper.instance.getDetail(widget.tag, widget.invNum);
    for (int i = 0; i < responseList.length; i++) {
      listItems.add(
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
        Text('${responseList[i].name}'),
        Text('${responseList[i].quantity}'),
        Text('${responseList[i].unitPrice}')
      ]));
    }
    return listItems;
  }

  @override
  void initState() {
    getDetail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        elevation: 0,
        leading: IconButton(
            icon: SvgPicture.asset("assets/icons/back_arrow.svg",
                color: Colors.white),
            onPressed: () => Navigator.pop(context)),
      ),
      body: FutureBuilder<List<Widget>>(
        future: getDetail(),
        builder: (BuildContext context, AsyncSnapshot<List<Widget>> snapshot) {
          return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: size.height,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: size.height * 0.3),
                        height: 500,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(24),
                            topRight: Radius.circular(24),
                          ),
                        ),
                        child: Column(
                          children: <Widget>[
                            for (int i = 0; i < listItems.length; i++)
                              listItems[i]
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: kDefaultPadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              widget.seller,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4
                                  ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                            ),
                            Text(widget.address,
                                style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
