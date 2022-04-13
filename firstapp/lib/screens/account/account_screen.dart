import 'package:flutter/material.dart';
import 'package:firstapp/screens/account/components/account_revise.dart';
import 'package:flutter_svg/svg.dart';
import '../../../constants.dart';

class AccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: AccountRevise(),
    );
  }

  AppBar buildAppBar(context) {
    return AppBar(
      backgroundColor: kPrimaryColor,
      elevation: 0,
      leading: IconButton(
        icon: SvgPicture.asset("assets/icons/back_arrow.svg"),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
