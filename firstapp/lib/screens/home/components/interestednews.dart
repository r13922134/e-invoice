import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'dart:math';
import 'package:html/parser.dart' as parser;
import 'package:firstapp/screens/account/components/account_revise.dart';
import 'package:flutter/material.dart';
import 'package:firstapp/constants.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:url_launcher/url_launcher.dart';




class Newslink {
  Newslink({
    required this.keyword,
    required this.title,
    required this.url,
  });
  String keyword;
  String title;
  String url;
}

Future<List<Newslink>> getnews2(String str) async {
    var client = http.Client();
    List<Newslink> tlist = [];
    String path = 'https://www.google.com/search?q=' + str + '&tbm=nws';

    try {
      var re = await http.get(Uri.parse(path));

      if (re.statusCode == 200) {
        BeautifulSoup soup = BeautifulSoup(re.body);
        String tmp2;
        String tmp;
        List<Bs4Element> r1 =
            soup.findAll('div', class_: 'Gx5Zad fP1Qef xpd EtOod pkphOe');
        for (Bs4Element b in r1) {
          tmp = b.find('a')?.getAttrValue('href') ?? '';
          tmp = tmp.substring(7);
          String searchString = '&sa';
          int index = tmp.indexOf(searchString);
          tmp = tmp.substring(0, index);
          tmp2 = b.getText().substring(0, 17)+"...";
          tlist.add(Newslink(keyword: str,title: tmp2, url: tmp));
        }
      }
    } catch (e) {
      print("error");
    }
    client.close();
    return tlist;
  }


/*Future<List<String>> getkeyword() async {
  final SharedPreferences pref = await SharedPreferences.getInstance();
  String? listString = pref.getString('select_diseases');
  List<Disease> _selectedDisease = [];
  List<String> _selectedkeywordlist = ["熬夜壞處"];
  if (listString != null) {
      _selectedDisease = Disease.decode(listString);
      for (Disease value in _selectedDisease){
        _selectedkeywordlist.add(value.name.toString());
      }
  return _selectedkeywordlist;
}*/


/*Future<List<Newslink>> get2url(String str) async{
  final SharedPreferences pref = await SharedPreferences.getInstance();
  String? listString = pref.getString('select_diseases');
  List<Disease> _selectedDisease = [];
  List<Newslink> resultnews = [];
  List<Newslink> resultError = [];
  List<String> _selectedkeywordlist = [];
  String c = str;
  if (listString != null) {
      _selectedDisease = Disease.decode(listString);
      for (Disease value in _selectedDisease){
        _selectedkeywordlist.add(value.name.toString());
      }
      c = _selectedkeywordlist[0];
  }
  else{
    c = '熬夜壞處';
  }


  String path1 = 'https://www.google.com/search?q=' + c;

  var response = await http.Client().get(Uri.parse(path1));
  if (response.statusCode == 200) {
    BeautifulSoup soup1 = BeautifulSoup(response.body);
    var document = parser.parse(response.body);
    try{
      List<Bs4Element> r1 = soup1.findAll("div", class_: "BNeawe vvjwJb AP7Wnd");
      String title = r1[1].getText().toString();
      String resulttitle = '';
      if(title.length > 19){
        resulttitle = title.substring(0, 18)+"...";
      }
      else{
        resulttitle = title;
      }
      List<Bs4Element> r2 = soup1.findAll("div", class_: "egMi0 kCrYT");
      const start = "/url?q=";
      const end = "&amp;sa";
      String noproceedurl = r2[0].a.toString();
      final startIndex = noproceedurl.indexOf(start);
      final endIndex = noproceedurl.indexOf(end, startIndex + start.length);
      String resulturl = noproceedurl.substring(startIndex + start.length, endIndex);
      resultnews.add(Newslink(keyword: c,title: resulttitle, url: resulturl));

      return resultnews;
    } 
    catch(e){
      resultError.add(Newslink(keyword: c,title: 'Error', url: 'Error'));
      return resultError;
    } 
  }else{
    
    
    resultError.add(Newslink(keyword: c,title: 'Error', url: response.statusCode.toString()));
    return resultError;
  }
  
}*/

/*Future<List<String>> get3url() async{
  final SharedPreferences pref = await SharedPreferences.getInstance();
  String? listString = pref.getString('select_diseases');
  List<Disease> _selectedDisease = [];
  List<String> _selectedkeywordlist = [];
  String c = '';
  if (listString != null) {
      _selectedDisease = Disease.decode(listString);
      for (Disease value in _selectedDisease){
        _selectedkeywordlist.add(value.name.toString());
      }
      
  }
  int lengthOfList = _selectedkeywordlist.length;

  if(lengthOfList > 1 && _selectedkeywordlist[lengthOfList-1] != null){
        c = _selectedkeywordlist[lengthOfList-1];
  }
  else{
    c = '維持體態';
  }


  String path1 = 'https://www.google.com/search?q=' + c;

  var response = await http.Client().get(Uri.parse(path1));
  if (response.statusCode == 200) {
    BeautifulSoup soup1 = BeautifulSoup(response.body);
    var document = parser.parse(response.body);
    try{
      List<Bs4Element> r1 = soup1.findAll("div", class_: "BNeawe vvjwJb AP7Wnd");
      String title = r1[1].getText().toString();
      String resulttitle = '';
      if(title.length > 19){
        resulttitle = title.substring(0, 18)+"...";
      }
      else{
        resulttitle = title;
      }
      List<Bs4Element> r2 = soup1.findAll("div", class_: "egMi0 kCrYT");
      const start = "/url?q=";
      const end = "&amp;sa";
      String noproceedurl = r2[0].a.toString();
      final startIndex = noproceedurl.indexOf(start);
      final endIndex = noproceedurl.indexOf(end, startIndex + start.length);
      String resulturl = noproceedurl.substring(startIndex + start.length, endIndex);

      return [c,resulttitle,resulturl];
    } 
    catch(e){
      return ['Error','Error','Error'];
    } 
  }else{
    return ['','','ERROR: ${response.statusCode}.'];
  }
 
}

Future<List<String>> get4url() async{
  final SharedPreferences pref = await SharedPreferences.getInstance();
  String? listString = pref.getString('select_diseases');
  List<Disease> _selectedDisease = [];
  List<String> _selectedkeywordlist = [];
  String c = '';
  if (listString != null) {
      _selectedDisease = Disease.decode(listString);
      for (Disease value in _selectedDisease){
        _selectedkeywordlist.add(value.name.toString());
      }
  }
  int lengthOfList = _selectedkeywordlist.length;

  if(lengthOfList > 2 &&_selectedkeywordlist[lengthOfList-2] != null){
        c = _selectedkeywordlist[lengthOfList-2];
  }
  else{
    c = '減脂飲食';
  }


  String path1 = 'https://www.google.com/search?q=' + c;

  var response = await http.Client().get(Uri.parse(path1));
  if (response.statusCode == 200) {
    BeautifulSoup soup1 = BeautifulSoup(response.body);
    var document = parser.parse(response.body);
    try{
      List<Bs4Element> r1 = soup1.findAll("div", class_: "BNeawe vvjwJb AP7Wnd");
      String title = r1[1].getText().toString();
      String resulttitle = '';
      if(title.length > 19){
        resulttitle = title.substring(0, 18)+"...";
      }
      else{
        resulttitle = title;
      }
      List<Bs4Element> r2 = soup1.findAll("div", class_: "egMi0 kCrYT");
      const start = "/url?q=";
      const end = "&amp;sa";
      String noproceedurl = r2[0].a.toString();
      final startIndex = noproceedurl.indexOf(start);
      final endIndex = noproceedurl.indexOf(end, startIndex + start.length);
      String resulturl = noproceedurl.substring(startIndex + start.length, endIndex);

      return [c,resulttitle,resulturl];
    } 
    catch(e){
      return ['Error','Error','Error'];
    } 
  }else{
    return ['','','ERROR: ${response.statusCode}.'];
  }
  
}*/

