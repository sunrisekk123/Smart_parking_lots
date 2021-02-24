import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class OrderDetailed extends StatefulWidget {

  @override
  _OrderDetailedPage createState() => _OrderDetailedPage();
}

class _OrderDetailedPage extends State<OrderDetailed> {
  List record = [];
  String email;
  DateTime _now;
  DateTime _end;
  Timer _timer;
  Future<void> setDataFuture;
  String reservationID,spaceID,carPlateNum,startTime,endTime,bookDate,status,staffID;
  DateTime endParkingTime;

  @override
  void dispose() {
    // Cancels the timer when the page is disposed.
    _timer.cancel();

    super.dispose();
  }



  @override
  void initState() {
    setDataFuture=showBookingData();
    super.initState();

  }
  Future<void> setCountDown() async {
    // Sets the current date time.
    _now = DateTime.now();
    // Sets the date time of the auction.
    // _end = new DateTime(2021, 1, 25, 17, 27);
    print(_end);

    // Creates a timer that fires every second.
    _timer = Timer.periodic(
        Duration(
          seconds: 1,
        ),
    (timer) {
      setState(() {
        // Updates the current date time.
        _now = DateTime.now();

        // If the auction has now taken place, then cancels the timer.
        if (_end.isBefore(_now)) {
          timer.cancel();
        }
      });
    }, );
  }




  Future<void> showBookingData() async{
    await getLoginEmail();
    await showCurrentBooking();
    await setBookingData();
    await setCountDown();
  }

  Future<void> getLoginEmail() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      email = preferences.getString('email');
    });
  }


  Future showCurrentBooking() async {
    var url="http://192.168.1.143/flutter_FYP_php/showCurrentBooking.php";
    //var url = "http://10.0.2.2/flutter_FYP_php/showCurrentBooking.php";
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
      }else{
        setState(() {
          record = json.decode(response.body);
        });
      }
    }
  }

  Future<void> setBookingData() async{
    reservationID=record[0]['Appointment_ID'];
    spaceID=record[0]['Space_ID'];
    carPlateNum=record[0]['CarPlateNumber'];
    startTime=record[0]['StartTime'];
    endTime=record[0]['EndTime'];
    _end=DateTime.parse(endTime);
    bookDate=record[0]['BookingDate'];
    status=record[0]['Status'];
    staffID=record[0]['Staff_ID'];

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
    body:FutureBuilder(
    future: setDataFuture,
    builder: (BuildContext context,AsyncSnapshot<void> snapshot){
    if(snapshot.connectionState != ConnectionState.done){
    return Container(child: Text('loading'),); // your widget while loading
    }

    if(snapshot.hasData){
    return Container(child: Text('wrong'),); //your widget when error happens
    }else{
      // Calculates the difference between the end date time and the current date time.
    final difference = _end.difference(_now);
        return SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.only(top: 0.0),
                child: Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.topLeft,
                      width: double.infinity,
                      margin: EdgeInsets.only(top: 1.0, bottom: 10),
                      padding: EdgeInsets.only(left: 20, top: 5, bottom: 5),
                      child: Text(
                        'Current Reservation',
                        style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.black54,
                            fontWeight: FontWeight.bold),
                      ),
                      color: Colors.orange.withOpacity(0.1),
                    ),
                    Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.white10.withOpacity(1),
                            border: Border.all(
                                color: Colors.blueGrey, // set border color
                                width: 1.0),
                            // set border width
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            // set rounded corner radius
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 10,
                                  color: Colors.blueGrey,
                                  offset: Offset(1, 3))
                            ] // make rounded corner of border
                            ),
                        margin: EdgeInsets.only(
                            top: 10, bottom: 5, left: 40, right: 40),
                        padding: EdgeInsets.all(20),
                        child: Column(
                          children: <Widget>[
                            Container(
                                alignment: Alignment.topCenter,
                                padding: const EdgeInsets.only(
                                  top: 5,
                                  bottom: 10,
                                ),
                                child: Row(children: <Widget>[
                                  Icon(Icons.access_alarms_outlined,
                                      color: Colors.black38),
                                  Text(
                                    ' Parking time ends in ',
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 20,
                                        fontStyle: FontStyle.italic),
                                  ),
                                ])),
                            Row(
                              // mainAxisAlignment: MainAxisAlignment.start,
                              // mainAxisSize: MainAxisSize.min,
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  flex: 4,
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        '${difference.inDays}',
                                        style: TextStyle(
                                            fontSize: 50,
                                            color: Colors.black54),
                                      ),
                                      Text('Days',
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontStyle: FontStyle.italic)),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        '${difference.inHours.remainder(24)}',
                                        style: TextStyle(
                                            fontSize: 50,
                                            color: Colors.black54),
                                      ),
                                      Text(
                                        'Hours',
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontStyle: FontStyle.italic),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        '${difference.inMinutes.remainder(60)}',
                                        style: TextStyle(
                                            fontSize: 50,
                                            color: Colors.black54),
                                      ),
                                      Text('minutes',
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontStyle: FontStyle.italic)),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        '${difference.inSeconds.remainder(60)}',
                                        style: TextStyle(
                                            fontSize: 50,
                                            color: Colors.black54),
                                      ),
                                      Text('seconds',
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontStyle: FontStyle.italic)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )),
                    Container(
                      color: Colors.blueAccent.withOpacity(0.1),
                      padding: EdgeInsets.all(20),
                      margin: EdgeInsets.only(top: 20,bottom: 20),
                      alignment: Alignment.centerLeft,

                      child:Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          RichText(
                            text: TextSpan(
                              text: "Reservation ID : ",
                              style: TextStyle(color: Colors.black87,fontSize:16 ),
                              children: <TextSpan>[
                                TextSpan(text: '$reservationID', style: TextStyle(color: Colors.black87,fontStyle: FontStyle.italic)),
                              ],
                            ),
                          ),
                          Padding(padding: EdgeInsets.all(2)),
                          RichText(
                            text: TextSpan(
                              text: "Space ID : ",
                              style: TextStyle(color: Colors.black87,fontSize:16 ),
                              children: <TextSpan>[
                                TextSpan(text: '$spaceID', style: TextStyle(color: Colors.red,fontStyle: FontStyle.italic)),
                              ],
                            ),
                          ),
                          Padding(padding: EdgeInsets.all(2)),
                          RichText(
                            text: TextSpan(
                              text: "Car Plate Number : ",
                              style: TextStyle(color: Colors.black87,fontSize:16 ),
                              children: <TextSpan>[
                                TextSpan(text: '$carPlateNum', style: TextStyle(color: Colors.black87,fontStyle: FontStyle.italic)),
                              ],
                            ),
                          ),
                          Padding(padding: EdgeInsets.all(2)),
                          RichText(
                            text: TextSpan(
                              text: "Start Parking Time : ",
                              style: TextStyle(color: Colors.black87,fontSize:16 ),
                              children: <TextSpan>[
                                TextSpan(text: '$startTime', style: TextStyle(color: Colors.black87,fontStyle: FontStyle.italic)),
                              ],
                            ),
                          ),
                          Padding(padding: EdgeInsets.all(2)),
                          RichText(
                            text: TextSpan(
                              text: "End Parking Time : ",
                              style: TextStyle(color: Colors.black87,fontSize:16 ),
                              children: <TextSpan>[
                                TextSpan(text: '$endTime', style: TextStyle(color: Colors.red,fontStyle: FontStyle.italic)),
                              ],
                            ),
                          ),
                          Padding(padding: EdgeInsets.all(2)),
                          RichText(
                            text: TextSpan(
                              text: "Booking Time : ",
                              style: TextStyle(color: Colors.black87,fontSize:16 ),
                              children: <TextSpan>[
                                TextSpan(text: '$bookDate', style: TextStyle(color: Colors.black87,fontStyle: FontStyle.italic)),
                              ],
                            ),
                          ),
                          Padding(padding: EdgeInsets.all(2)),
                          RichText(
                            text: TextSpan(
                              text: "Status : ",
                              style: TextStyle(color: Colors.black87,fontSize:16 ),
                              children: <TextSpan>[
                                TextSpan(text: '$status', style: TextStyle(color: Colors.red,fontStyle: FontStyle.italic)),
                              ],
                            ),
                          ),
                          Padding(padding: EdgeInsets.all(2)),
                          RichText(
                            text: TextSpan(
                              text: "Staff ID : ",
                              style: TextStyle(color: Colors.black87,fontSize:16 ),
                              children: <TextSpan>[
                                TextSpan(text: '$staffID', style: TextStyle(color: Colors.black87,fontStyle: FontStyle.italic)),
                              ],
                            ),
                          ),

                        ],
                      ),
                    ),
                    RaisedButton(
                        color: Colors.black,
                        splashColor: Colors.black,
                        elevation: 20.0,
                        padding: EdgeInsets.only(top: 0.0, bottom: 0.0,left: 0,right: 0),


                        child: Container(
                          width: double.infinity,
                          margin: EdgeInsets.all(0),
                          padding: EdgeInsets.only(top: 10.0, bottom: 10.0,left: 0,right: 0),

                          decoration: new BoxDecoration(
                            gradient: new LinearGradient(
                              colors: [
                                Color.fromRGBO(227, 239, 255, 1),
                                Color.fromRGBO(255, 255, 255, 1),
                                // Color.fromRGBO(255, 228, 240, 1),
                                Color.fromRGBO(254, 234, 224, 1),

                              ],
                            ),
                            borderRadius: new BorderRadius.all(const Radius.circular(30.0)),

                          ),
                          child: Column( // Replace with a Row for horizontal icon + text
                            children: <Widget>[
                              GlowText(
                                'Car Location',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.blueGrey,fontStyle:FontStyle.italic ),),
                              Container(
                                child: new Image.asset('assets/images/car.png',width: 60,),
                              )
                            ],

                          ),),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        onPressed: (){
                          // Navigator.push(context,MaterialPageRoute(builder: (context)=>GoToParking()));
                        }
                    ),
                  ],
                )));}}));
  }
}
