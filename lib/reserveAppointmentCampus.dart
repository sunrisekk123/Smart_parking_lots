import 'dart:convert';
import 'dart:ui';

import 'package:intl/intl.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_button/flutter_button.dart';
import 'package:flutter_first/homepage1.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'reserveAppointment.dart';

class ReserveAppointmentCampus extends StatefulWidget {
  @override
  _ReserveAppointmentCampus createState() => _ReserveAppointmentCampus();
}

class _ReserveAppointmentCampus extends State<ReserveAppointmentCampus> {
  final _formKey = GlobalKey<FormState>();
  List allCampus = [];
  var email = "";
  var id = "";
  var carPlateNumber = "";
  var _setDate = "";
  var _setEndTime = "";
  var _setStartTime = "";
  final String title = "";
  int _currentIndex;
  TextEditingController startTimeCon = TextEditingController();
  TextEditingController endTimeCon = TextEditingController();
  TextEditingController bookingDateCon = TextEditingController();
  TextEditingController carPlateNumberCon = TextEditingController();
  List record = [];
  static final DateTime now = DateTime.now();

  Future showProfile() async {
    var url = "http://192.168.1.143/flutter_FYP_php/showProfile.php";
    //var url = "http://10.0.2.2/flutter_FYP_php/showProfile.php";
    var response = await http.post(url, body: {
      "email": email,
    });
    var data = json.decode(response.body);

    if (response.statusCode == 200) {
      if (data == "error") {
        Fluttertoast.showToast(
            msg: "Data is not found ",
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

  Future<void> getLoginEmail() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      email = preferences.getString('email');
    });
  }

  void initState() {
    allCampus = getCampusInfo();
    super.initState();
    showUserData();
  }

  Future<void> showUserData() async {
    await getLoginEmail();
    await showProfile();
    await setUserData();
  }

  Future<void> setUserData() async {
    id = record[0]['Member_ID'];
    startTimeCon.text = _setStartTime;
    endTimeCon.text = _setEndTime;
    bookingDateCon.text = _setDate;
    carPlateNumberCon.text = record[0]['MemberType'];
    if (record[0]['MemberType'] == 'lecturer') {
      _currentIndex = 0;
    } else if (record[0]['MemberType'] == 'guest') {
      _currentIndex = 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Image.asset(
              'assets/images/barLogo.png',
              fit: BoxFit.contain,
              height: 40,
            ),
          ]),
          backgroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.only(top: 0.0,bottom: 5.0),
                child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.topLeft,
                          width: double.infinity,
                          margin: EdgeInsets.only(top: 2.0, bottom: 10),
                          padding: EdgeInsets.only(left: 20, top: 5, bottom: 5),
                          child: Text(
                            'Appointment ',
                            style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.black54,
                                fontWeight: FontWeight.bold),
                          ),
                          color: Colors.orange.withOpacity(0.1),
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          width: double.infinity,
                          margin: EdgeInsets.only(top: 2.0, bottom: 10),
                          padding: EdgeInsets.only(left: 20, top: 5, bottom: 5),
                          child: Text(
                            'Member ID :$id',
                            style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.black54,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        LocationCard1(), // Row
                      ],
                    )))));
  }
}

class LocationCard1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Card makeCard(Campus campus) => Card(
          elevation: 8.0,
          margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          child: Container(
            child: new Column(children: [
              ListTile(
                title: new Text(campus.title,
                    style: new TextStyle(
                        fontSize: 18.0, fontWeight: FontWeight.bold)),
                subtitle: Text(campus.subtitle),
              ),
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                ),
                title: new Center(
                    child: new Text(
                  "Book Now",
                  style: new TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20.0,
                      color: Colors.white),
                )),
                tileColor: campus.tileColor,
                onTap: () {
                  if (campus.title == "Tsing Yi Campus") {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ReserveAppointment(campus: campus)));
                  } else {
                    Fluttertoast.showToast(
                        msg: "Not available yet",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1);
                  }
                },
              )
            ]),
          ),
        );

    return new Container(
          alignment: Alignment.center,
          width: double.infinity,
          padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
        child: SizedBox(
          height: 460,
            child: ListView.builder(
              //physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            //shrinkWrap: true,
            itemCount: getCampusInfo().length,
            itemBuilder: (BuildContext context, int index) {
              return makeCard(getCampusInfo()[index]);
            },
          ),
    )
        );
  }
}

List getCampusInfo() {
  return [
    Campus(
        title: "Tsing Yi Campus",
        subtitle: "20 Tsing Yi Road, Tsing Yi Island, New Territories",
        tileColor: Colors.deepOrange),
    Campus(
        title: "Sha Tin Campus",
        subtitle: "21 Yuen Wo Road, Sha Tin, New Territories",
        tileColor: Colors.black45),
    Campus(
        title: "Tuen Mun Campus",
        subtitle: "18 Tsing Wun Road, Tuen Mun, New Territories",
        tileColor: Colors.black45),
    Campus(
        title: "LWL Campus",
        subtitle: "3 King Ling Road, Tseung Kwan O, New Territories",
        tileColor: Colors.black45),
    Campus(
        title: "Chai Wan Campus",
        subtitle: "30 Shing Tai Road, Chai Wan, Hong Kong",
        tileColor: Colors.black45),
    Campus(
        title: "Morrison Hill Campus",
        subtitle: "6 Oi Kwan Road, Wan Chai, Hong Kong",
        tileColor: Colors.black45),
  ];
}

class Campus {
  String title;
  String subtitle;
  Color tileColor;

  Campus({this.title, this.subtitle, this.tileColor});
}
