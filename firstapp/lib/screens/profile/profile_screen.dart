import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:firstapp/screens/profile/components/body.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  @override
  _IdentityPageState createState() => _IdentityPageState();
}

class _IdentityPageState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
     
  }

  @override
  Widget build(BuildContext context) {
    return Body();
  }
}
