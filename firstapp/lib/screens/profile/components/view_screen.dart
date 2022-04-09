import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewProfile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<ViewProfile> {
  String? profileValue;
  @override
  void initState() {
    super.initState();
    getProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("View Profile"),
      ),
      body: Center(
        child: profileValue == null
            ? Text('no value available')
            : Text(profileValue!),
      ),
    );
  }

  void getProfile() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    profileValue = pref.getString('profileData');
    setState(() {});
  }
}
