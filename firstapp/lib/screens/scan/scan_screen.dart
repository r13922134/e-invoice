import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../constants.dart';
import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({Key? key}) : super(key: key);
  @override
  _IdentityPageState createState() => _IdentityPageState();
}

class _IdentityPageState extends State<ScanScreen> {

  Future<void> _handleRefresh() async {
    return await Future.delayed(Duration(seconds: 2 ));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      backgroundColor: Color(0xFFF9F8FD),
      body : LiquidPullToRefresh(
        onRefresh: _handleRefresh,
        color: Color.fromARGB(255, 98, 152, 168),
        height: 180,
        backgroundColor: Color.fromARGB(255, 193, 216, 223),
        animSpeedFactor: 2.0,
        showChildOpacityTransition: false,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  height: 300,
                  color: Color.fromARGB(255, 98, 152, 168),
                 ),
              ),
            ),   
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  height: 300,
                  color: Color.fromARGB(255, 98, 152, 168),
                 ),
              ),
            ),     
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  height: 300,
                  color: Color.fromARGB(255, 98, 152, 168),
                 ),
              ),
            ),         
          ],
        ),
      )
      //appBar: buildAppBar(), 
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: kPrimaryColor,
      elevation: 0,
      leading: IconButton(
        icon: SvgPicture.asset("assets/icons/menu.svg"),
        onPressed: () {},
      ),
    );
  }
}
