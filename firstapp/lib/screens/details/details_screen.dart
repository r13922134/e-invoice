import 'package:firstapp/constants.dart';
import 'package:flutter/material.dart';
import 'package:firstapp/database/details_database.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firstapp/screens/details/detail_model.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({
    Key? key,
    required this.tag,
    required this.invDate,
    required this.seller,
    required this.address,
    required this.invNum,
    required this.time,
    required this.amount,
  }) : super(key: key);

  final String tag, invDate, invNum, seller, address, time, amount;
  @override
  _InvoiceDetail createState() => _InvoiceDetail();
}

class _InvoiceDetail extends State<DetailsScreen> {
  List<invoice_details> tmp = [];

  Future<List<invoice_details>> getDetail() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String? barcode = pref.getString('barcode')!;
    String? password = pref.getString('password')!;
    int timestamp = DateTime.now().millisecondsSinceEpoch + 100;
    int exp = timestamp + 200;

    List<invoice_details> responseList = [];
    responseList =
        await DetailHelper.instance.getDetail(widget.tag, widget.invNum);
    if (responseList.isEmpty) {
      http.Response response;
      response = await http.post(
          Uri.https("api.einvoice.nat.gov.tw", "PB2CAPIVAN/invServ/InvServ"),
          body: {
            "version": "0.5",
            "cardType": "3J0002",
            "cardNo": barcode,
            "expTimeStamp": exp.toString(),
            "action": "carrierInvDetail",
            "timeStamp": timestamp.toString(),
            "invNum": widget.invNum.toString(),
            "invDate": widget.invDate.toString(),
            "uuid": '1000',
            "sellerName": widget.seller.toString(),
            "amount": widget.amount.toString(),
            "appID": 'EINV0202204156709',
            "cardEncrypt": password,
          });
      String responseString = response.body;
      List<Details> tmp = detailModelFromJson(responseString).details;

      for (Details element in tmp) {
        await DetailHelper.instance.add(invoice_details(
            tag: widget.tag.toString(),
            invNum: widget.invNum.toString(),
            name: element.description,
            date: widget.invDate.toString(),
            quantity: element.quantity,
            amount: element.amount));
      }
      responseList =
          await DetailHelper.instance.getDetail(widget.tag, widget.invNum);
    }
    return responseList;
  }

  @override
  void initState() {
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
      body: FutureBuilder<List<invoice_details>>(
        future: getDetail(),
        builder: (BuildContext context,
            AsyncSnapshot<List<invoice_details>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: size.height,
                    child: Stack(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: size.height * 0.3),
                          height: 700,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(24),
                              topRight: Radius.circular(24),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(25),
                            child: Column(
                              children: <Widget>[
                                SizedBox(height: 30),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("品名"),
                                    Text(
                                        "                                                              數量"),
                                    Text("小計  ")
                                  ],
                                ),
                                SizedBox(height: 30),
                                for (invoice_details value
                                    in snapshot.data ?? tmp)
                                  (CustomRow(
                                      name: value.name,
                                      quentity: value.quantity,
                                      price: value.amount)),
                                Text("\n\n\n\n總計   \$" + widget.amount)
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: kDefaultPadding),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                widget.invNum,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline4
                                    ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 15),
                              Text(widget.seller,
                                  style: TextStyle(color: Colors.white)),
                              Text(widget.address,
                                  style: TextStyle(color: Colors.white)),
                              Text(widget.invDate,
                                  style: TextStyle(color: Colors.white)),
                              Text(widget.time,
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
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class CustomRow extends StatelessWidget {
  final String name;
  final String quentity;
  final String price;

  const CustomRow(
      {Key? key,
      required this.name,
      required this.quentity,
      required this.price})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 6, // Change this property to align your content

            child: Text(
              name, // Name
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black,
                decoration: TextDecoration.none,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          SizedBox(height: 40),
          Expanded(
            flex: 1, // Change this property to align your content
            child: Text(
              "x" + quentity, // Name
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black,
                decoration: TextDecoration.none,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Expanded(
            flex: 1, // Change this property to align your content
            child: Text(
              price, // Name
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black,
                decoration: TextDecoration.none,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
