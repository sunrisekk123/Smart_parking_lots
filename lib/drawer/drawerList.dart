import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_first/Myprofile.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../splash_page.dart';

class DrawerList extends StatefulWidget {
  @override
  _Drawer createState() => _Drawer();
}

class _Drawer extends State<DrawerList> {
  var email = "";
  var fName = "";
  List record = [];

  Future getLoginEmail() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      email = preferences.getString('email');
    });
  }

  void initState() {
    super.initState();
    showUserData();
  }

  Future<void> showUserData() async {
    await getLoginEmail();
    await showProfile();
    await setUserData();
  }

  Future<void> setUserData() async {
    fName = record[0]['FirstName'];
  }

  Future showProfile() async {
     var url="http://192.168.1.143/flutter_FYP_php/showProfile.php";
    //var url = "http://10.0.2.2/flutter_FYP_php/showProfile.php";
    var response = await http.post(url, body: {
      "email": email,
    });
    var data = json.decode(response.body);

    if (response.statusCode == 200) {
      if (data == "error") {
        Fluttertoast.showToast(
            msg: "Data is not found",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        setState(() {
          record = json.decode(response.body);
        });
      }
    }
  }

  Future logout(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove('email');
    Fluttertoast.showToast(
        msg: "Logout  Successful",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
        fontSize: 16.0);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SplashPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        UserAccountsDrawerHeader(
            accountName: Text(
              'Hi, $fName',
              style: TextStyle(color: Colors.white),
            ),
            accountEmail: Text('$email', style: TextStyle(color: Colors.white)),
            currentAccountPicture: CircleAvatar(
              radius: 55.0,
              backgroundColor: Colors.white,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(53),
                child: Image.asset(
                  'assets/images/icons/boy.png',
                  width: 500,
                ),
              ),
            ),
            decoration: BoxDecoration(color: Colors.brown.withOpacity(0.6)),
            otherAccountsPictures: <Widget>[
              new CircleAvatar(
                backgroundColor: Colors.transparent,
                child: IconButton(
                  icon: Icon(Icons.create_sharp),
                  tooltip: 'Edit',
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Myprofile()));
                  },
                ),
              ),
            ]),
        ListTile(
          leading: Icon(Icons.assignment_late),
          title: Text('About Us'),
          // onTap: () => _openAppointmentPage(context),
        ),
        ListTile(
          leading: Icon(Icons.message),
          title: Text('Messages'),
        ),
        ListTile(
          leading: Icon(Icons.settings),
          title: Text('Settings'),
        ),
        ListTile(
          leading: Icon(Icons.call_missed_outgoing),
          title: Text('Logout'),
          onTap: () {
            logout(context);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
