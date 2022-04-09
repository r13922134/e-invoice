import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'view_screen.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Body> {
  final profileController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: profileController,
            decoration: InputDecoration(hintText: "Enter proifle"),
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
            child: Text('Save'),
            onPressed: () {
              setProfile(profileController.text);
            },
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
            child: Text('View'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ViewProfile(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> setProfile(profileValue) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('profileData', profileValue);
  }
}
