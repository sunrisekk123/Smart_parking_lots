import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_button/flutter_button.dart';
import 'package:flutter_first/homepage1.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'reserveAppointmentCampus.dart';

class ReserveAppointment extends StatefulWidget {
  final Campus campus;
  ReserveAppointment({Key key, this.campus}) : super(key: key);
  @override
  _ReserveAppointment createState() => _ReserveAppointment();
}

class _ReserveAppointment extends State<ReserveAppointment> {
  final _formKey = GlobalKey<FormState>();
  var email = "";
  var id = "";
  var carPlateNumber = "";
  var _setDate = "";
  var _setEndTime = "";
  var _setStartTime = "";
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

  Future<void> insertAppointment() async {
    var url = "http://192.168.1.143/flutter_FYP_php/reserveAppointment.php";
    //var url="http://10.0.2.2/flutter_FYP_php/reserveAppointment.php";

    var response = await http.post(url, body: {
      "startTime": startTimeCon.text,
      "endTime": endTimeCon.text,
      "bookingDate": now,
      "carPlateNumber": carPlateNumberCon.text,
      "id": id,
    });
    var data = json.decode(response.body);

    if (data == "Success") {
      Fluttertoast.showToast(
          msg: "Edit  Successful",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => ReserveAppointment()));
    } else {
      Fluttertoast.showToast(
          msg: data,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  Future<void> getLoginEmail() async {
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

  TextEditingController _boxOldPwCon = TextEditingController();
  TextEditingController _boxNewPwCon1 = TextEditingController();
  TextEditingController _boxNewPwCon2 = TextEditingController();
  String codeDialog;
  String boxOldPW;
  String boxNewPW1;
  String boxNewPW2;
  final _editPwKey = GlobalKey<FormState>();

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
                padding: EdgeInsets.only(top: 0.0),
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
                        Container(
                          alignment: Alignment.center,
                          width: double.infinity,
                          margin: EdgeInsets.only(top: 2.0, bottom: 10),
                          padding: EdgeInsets.only(left: 20, top: 5, bottom: 5),
                          child: new ExpansionTile(
                              leading: Icon(Icons.book),
                              title: Text('Tsing Yi Campus'),
                              children: <Widget>[
                                new Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    new Container(
                                      padding: EdgeInsets.all(20),
                                      height: 100,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        color: Colors.blueGrey,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Text("Year"),
                                    ),
                                    new Container(
                                      padding: EdgeInsets.all(20),
                                      height: 100,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        color: Colors.blueGrey,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Text("Month"),
                                    ),
                                    new Container(
                                      padding: EdgeInsets.all(20),
                                      height: 100,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        color: Colors.blueGrey,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Text("Day"),
                                    ),
                                  ],
                                ),

                              ]
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          width: double.infinity,
                          margin: EdgeInsets.only(top: 2.0, bottom: 10),
                          padding: EdgeInsets.only(left: 20, top: 5, bottom: 5),
                          child: new ExpansionTile(
                              leading: Icon(Icons.book),
                              title: Text('1. Appointment Date'),
                              children: <Widget>[
                                new Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    new Container(
                                      padding: EdgeInsets.all(20),
                                      height: 100,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        color: Colors.blueGrey,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Text("Year"),
                                    ),
                                    new Container(
                                      padding: EdgeInsets.all(20),
                                      height: 100,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        color: Colors.blueGrey,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Text("Month"),
                                    ),
                                    new Container(
                                      padding: EdgeInsets.all(20),
                                      height: 100,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        color: Colors.blueGrey,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Text("Day"),
                                    ),
                                  ],
                                ),

                              ]
                          ),
                        ), // Row(
                        //   children: <Widget>[
                        //     Expanded(
                        //         child: Row(
                        //           children: <Widget>[
                        //             Expanded(
                        //               flex: 4,
                        //               child: TextFormField(
                        //                 controller: startTimeCon,
                        //                 validator: _validatefName,
                        //                 keyboardType: TextInputType.text,
                        //                 textInputAction: TextInputAction.next,
                        //                 onSaved: (String val) {
                        //                   _setStartTime = val;
                        //                 },
                        //                 decoration: InputDecoration(
                        //                     labelText: 'Start Time',
                        //                     icon: Icon(
                        //                       Icons.access_time,
                        //                       color: Colors.black38,
                        //                     )),
                        //                 onTap: () async{
                        //                   DatePicker.showDateTimePicker(context,
                        //                       showTitleActions: true,
                        //                       minTime: now,
                        //                       maxTime: DateTime(now.year+1, now.month, now.day, 00, 00),
                        //                       onChanged: (date) {
                        //                     print('change $date in time zone ' + date.timeZoneOffset.inHours.toString());
                        //                   }, onConfirm: (date) {
                        //                         String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(date);
                        //                         startTimeCon.text = formattedDate;
                        //                     print('confirm $date');
                        //                   }, currentTime: now);
                        //                 }
                        //               ),
                        //             ),
                        //             Expanded(
                        //               flex: 4,
                        //               child: TextFormField(
                        //                 controller: endTimeCon,
                        //                 validator: _validatelName,
                        //                 keyboardType: TextInputType.text,
                        //                 textInputAction: TextInputAction.next,
                        //                   onSaved: (String val) {
                        //                     _setEndTime = val;
                        //                   },
                        //                 decoration: InputDecoration(
                        //                     labelText: 'End Time',
                        //                     icon: Icon(
                        //                       Icons.access_time,
                        //                       color: Colors.black38,
                        //                     )),
                        //                   onTap: () async{
                        //                     DatePicker.showDateTimePicker(context,
                        //                         showTitleActions: true,
                        //                         minTime: now,
                        //                         maxTime: DateTime(now.year+1, now.month, now.day, 00, 00),
                        //                         onChanged: (date) {
                        //                           print('change $date in time zone ' + date.timeZoneOffset.inHours.toString());
                        //                         }, onConfirm: (date) {
                        //                           String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(date);
                        //                           endTimeCon.text = formattedDate;
                        //                           print('confirm $date');
                        //                         }, currentTime: now);
                        //                   }
                        //               ),
                        //             )
                        //           ],
                        //         ))
                        //   ],
                        // ),
                        // Container(
                        //     child: TextFormField(
                        //       controller: carPlateNumberCon,
                        //       //validator: _validatePhoneNum,
                        //       keyboardType: TextInputType.text,
                        //       textInputAction: TextInputAction.next,
                        //       decoration: InputDecoration(
                        //           labelText: 'Car plate No.',
                        //           icon: Icon(
                        //             Icons.local_phone,
                        //             color: Colors.black38,
                        //           )),
                        //     )),

                        Container(
                            // margin: EdgeInsets.only(top: 0,bottom:0),
                            // padding: EdgeInsets.only(top: 0,bottom: 0),
                            width: double.infinity,
                            height: 100,
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top: 0.0,
                                        bottom: 0.0,
                                        left: 10,
                                        right: 10),
                                    child: FlatButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Homepage1()));
                                      },
                                      child: Text('Back',
                                          style: TextStyle(
                                            color: Colors.blue,
                                            fontSize: 16,
                                          )),
                                      textColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                              color: Colors.blue,
                                              width: 1,
                                              style: BorderStyle.solid),
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top: 0.0,
                                        bottom: 0.0,
                                        left: 10,
                                        right: 10),
                                    child: FlatButton(
                                      onPressed: () {
                                        if (_formKey.currentState.validate()) {
                                          insertAppointment();
                                        }
                                      },
                                      child: Text('Reserve',
                                          style: TextStyle(
                                            color: Colors.blue,
                                            fontSize: 16,
                                          )),
                                      textColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                              color: Colors.blue,
                                              width: 1,
                                              style: BorderStyle.solid),
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                    ),
                                  ),
                                )
                              ],
                            ))
                      ],
                    )))));
  }

  String _validatefName(String value) {
    return value.trim().isEmpty ? "Please Input First Name" : null;
  }

  String _validatelName(String value) {
    return value.trim().isEmpty ? "Please Input Last Name" : null;
  }

  String _validatePassword(String value) {
    return value.length < 5 ? 'Minimum 5 characters required' : null;
  }

  String _validatePassword2(String value) {
    if (value.length < 5)
      return 'Minimum 5 characters required';
    else if (value != _boxNewPwCon1.text) return "Password are not matching";
    return null;
  }

  String _validatePhoneNum(String value) {
    if (value.length != 8)
      return 'Phone number must be of 8 digits';
    else
      return null;
  }

  String _validatelOldPw(String value) {
    if (value.length < 5)
      return 'Minimum 5 characters required';
    else if (value == '0') return "Wrong Old Password";
    return null;
  }

  String _validateType(String value) {
    if (value == 'lecturer' || value == 'guest')
      return null;
    else
      return "Wrong Member Type";
  }

  Future<void> editPW() async {
    var url = "http://192.168.1.143/flutter_FYP_php/checkOldPW.php";
    //var url="http://10.0.2.2/flutter_FYP_php/checkOldPW.php";

    var response = await http.post(url, body: {
      "id": id,
      "oldPassword": _boxOldPwCon.text,
      "newPassword": _boxNewPwCon1.text,
    });
    var data = json.decode(response.body);

    if (data == "NotFound") {
      Fluttertoast.showToast(
          msg: "Wrong Old Password",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          fontSize: 16.0);
    } else if (data == "Success") {
      Fluttertoast.showToast(
          msg: "Edit Password Successful",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          fontSize: 16.0);
      codeDialog = boxNewPW1;

      Navigator.pop(context);
    } else if (data == "Error") {
      Fluttertoast.showToast(
          msg: "New Password Can Not Same As Old",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    _boxNewPwCon1.text = "";
    _boxNewPwCon2.text = "";
    _boxOldPwCon.text = "";
  }
}
