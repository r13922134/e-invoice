import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'dart:math';
import 'package:html/parser.dart' as parser;
import 'package:firstapp/screens/account/components/account_revise.dart';

/*List<String> keywordlist = ['維持體態','多喝水好處'];
List<String> _selectedkeywordlist = [];
void getselectedkeyword() async {
  final SharedPreferences pref = await SharedPreferences.getInstance();
  String? listString = pref.getString('select_diseases');
  //List<String> _selectedkeywordlist = [];
  List<Disease> _selectedDisease = [];
  if (listString != null) {
      _selectedDisease = Disease.decode(listString);
      for (Disease value in _selectedDisease){
        _selectedkeywordlist.add(value.name.toString());
      }
  }
}*/
/*void getkeyword(){
  getselectedkeyword();
  if(_selectedkeywordlist[0]==null){
    return 
  }
}*/
//bool isLoading = false;
//String keyword = '';

/*Future<List<String>> geturl(String keyword) async{
  //String c = "多喝水好處";
   String c = keyword;
  //final SharedPreferences pref = await SharedPreferences.getInstance();
  //var client = http.Client();
  //int index_count = 1;

  String path1 = 'https://www.google.com/search?q=' + c;

  var response = await http.Client().get(Uri.parse(path1));
  if (response.statusCode == 200) {
    BeautifulSoup soup1 = BeautifulSoup(response.body);
    var document = parser.parse(response.body);
    try{
      //var responseString1 = document.getElementsByClassName('rQMQod Xb5VRe')[0];
      //var responseString2 = document.getElementsByTagName('a href')[0];
      //var responseString1 = soup1.find("span", class_: "rQMQod Xb5VRe");
      //String result1 = responseString1.text;
      //var responseString2 = document.getElementsByClassName('rQMQod Xb5VRe')[0];
      //String result2 = responseString2.text;
      //List<Bs4Element> r1 = soup1.findAll("div", class_: "egMi0 kCrYT");
      //var refind2 = soup1.find("div", class_: "egMi0 kCrYT");
      //var idk = refind2.contents;
      //var idk = document.getElementsByClassName('egMi0 kCrYT')[0].firstChild;
      //var refind = soup1.find("span", class_: "rQMQod Xb5VRe");
      List<Bs4Element> r1 = soup1.findAll("div", class_: "BNeawe vvjwJb AP7Wnd");
      String resulttitle = r1[1].getText().toString();
      List<Bs4Element> r2 = soup1.findAll("div", class_: "egMi0 kCrYT");
      const start = "/url?q=";
      const end = "&amp;sa";
      String noproceedurl = r2[0].a.toString();
      final startIndex = noproceedurl.indexOf(start);
      final endIndex = noproceedurl.indexOf(end, startIndex + start.length);
      String resulturl = noproceedurl.substring(startIndex + start.length, endIndex);

      
      //var refind3 = refind2.children;

      /*for (int i = 1; i < 2; i += 1){
        if(r1[i].find("a href") != null){
          /*n1.add(Newscard(title: c,
                          resulttitle: soup1.find("h3", class_: "LC20lb MBeuO DKV0Md").toString(),
                          link:bs4.findAll("a href").toString()));*/
          var refind2 =r1[i].find("a href").text.trim();
          
        }  
      }*/
      //String result = r1[0].getText().toString() ;
      //String result = r2[0].a.toString() ;
      return [resulttitle,resulturl];
    } 
    catch(e){
      /*n1.add(Newscard(title: c,
                          resulttitle: "Error",
                          link:"Error"));*/
      return ['Error','Error'];
    } 
  }else{
    return ['','ERROR: ${response.statusCode}.'];
  }
  //client.close();
  //return n1;
}*/

Future<List<String>> get2url() async{
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

      return [c,resulttitle,resulturl];
    } 
    catch(e){
      return ['Error','Error','Error'];
    } 
  }else{
    return ['','','ERROR: ${response.statusCode}.'];
  }
  
}

Future<List<String>> get3url() async{
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
  
}

