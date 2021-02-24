import 'dart:convert';
import 'package:flutter_first/CanceldetailPage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading/indicator/ball_grid_pulse_indicator.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/indicator/ball_spin_fade_loader_indicator.dart';
import 'package:loading/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class MyReservation extends StatefulWidget {
  @override
  MyReservationPage createState() => MyReservationPage();
}

class MyReservationPage extends State<MyReservation> {
  String email;
  List<bool> isSelected;
  final List statusName = [
    'waiting',
    'confirmed',
    'parking',
    'complete',
    'cancel'
  ];
  String selectedStatus;
  List record = [];
  Future<List> setDataFuture;

  @override
  void initState() {
    getLoginEmail();
    isSelected = [true, false, false, false, false];
    selectedStatus = "waiting";
    super.initState();
    setDataFuture = showBookingData();
  }

  Future<void> getLoginEmail() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      email = preferences.getString('email');
    });
  }

  Future<List> showBookingData() async {
    var url="http://192.168.1.143/flutter_FYP_php/showBookingData.php";
    //var url = "http://10.0.2.2/flutter_FYP_php/showBookingData.php";
    var response = await http.post(url, body: {
      "email": email,
      "status": selectedStatus,
    });
    // var data = json.decode(response.body);

    return json.decode(response.body);
  }

  Future<void> cancelBooking(String appointmentID) async {
    var url="http://192.168.1.143/flutter_FYP_php/cancelBooking.php";
    //var url = "http://10.0.2.2/flutter_FYP_php/cancelBooking.php";
    var response = await http.post(url, body: {
      "appointmentID": appointmentID,
    });
    var data = json.decode(response.body);

    if (response.statusCode == 200) {
      if (data == "error") {
        Fluttertoast.showToast(
            msg: "Cancel Reservation Failed. Please contact parking manager.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }else{
        Fluttertoast.showToast(
            msg: "Cancel Reservation Successful",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.blue,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }

  }

  Future<void>  _confirmDialog(BuildContext context, String appointmentID,String startTime,String endTime) async {
    return showDialog(
        context: context,
        builder: (context) {
          return  AlertDialog(
            content: Container(
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text("Are you sure cancel booking  "),
                RichText(
                  text: TextSpan(
                    text: "from ",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,),
                    children: <TextSpan>[
                      TextSpan(
                          text: '$startTime',
                          style: TextStyle(
                              color:
                              Colors.red)),
                    ],
                  ),
                ),

                RichText(
                  text: TextSpan(
                    text: "to ",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16, ),
                    children: <TextSpan>[
                      TextSpan(
                          text: '$endTime',
                          style: TextStyle(
                              color:
                              Colors.red)),
                      TextSpan(
                          text: '?'),
                    ],
                  ),
                ),

              ],
            ),),

            actions: <Widget>[

              FlatButton(
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
                child: Text('No', style: TextStyle(
                  color: Colors.red,fontSize: 16,
                )
                ),
                shape: RoundedRectangleBorder(side: BorderSide(
                    color: Colors.red,
                    width: 1,
                    style: BorderStyle.solid
                ), borderRadius: BorderRadius.circular(50)),
              ),

              FlatButton(
                child: Text('Yes', style: TextStyle(
                  color: Colors.blue,fontSize: 16,
                )
                ),
                onPressed: ()  {
                  setState(() {
                    Navigator.pop(context);
                    cancelBooking(appointmentID);
                    setDataFuture = showBookingData();

                  });

                },

                shape: RoundedRectangleBorder(side: BorderSide(
                    color: Colors.blue,
                    width: 1,
                    style: BorderStyle.solid
                ), borderRadius: BorderRadius.circular(50)),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        // color: Colors.blue.withOpacity(1),
        child: Scaffold(
            backgroundColor: Colors.blue[50],
            body: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.topLeft,
                    width: double.infinity,
                    margin: EdgeInsets.only(top: 0.0, bottom: 0),
                    padding: EdgeInsets.only(left: 10, top: 5, bottom: 0),
                    child: ToggleButtons(
                      selectedColor: Colors.blue,
                      selectedBorderColor: Colors.blue,
                      color: Colors.black54,
                      renderBorder: false,
                      textStyle: TextStyle(fontSize: 16),

                      // borderRadius:new BorderRadius.all(const Radius.circular(30.0)),
                      children: <Widget>[
                        Container(
                            width: (MediaQuery.of(context).size.width - 20) / 5,
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[Text("${statusName[0]}")],
                            )),
                        Container(
                            width: (MediaQuery.of(context).size.width - 20) / 5,
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[Text("${statusName[1]}")],
                            )),
                        Container(
                            width: (MediaQuery.of(context).size.width - 20) / 5,
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[Text("${statusName[2]}")],
                            )),
                        Container(
                            width: (MediaQuery.of(context).size.width - 20) / 5,
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[Text("${statusName[3]}")],
                            )),
                        Container(
                            width: (MediaQuery.of(context).size.width - 20) / 5,
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[Text("${statusName[4]}")],
                            )),
                      ],
                      onPressed: (int index) {
                        setState(() {
                          for (int i = 0; i < isSelected.length; i++) {
                            isSelected[i] = i == index;
                          }
                          print(statusName[index]);
                          selectedStatus = statusName[index];
                          setDataFuture = showBookingData();
                        });
                      },
                      isSelected: isSelected,
                    ),
                    color: Colors.orange[50],
                  ),
                  FutureBuilder(
                      future: setDataFuture,
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.connectionState != ConnectionState.done) {
                          return Container(
                            height: MediaQuery.of(context).size.height - 300,
                            alignment: Alignment.center,
                            child: Center(
                              child: Loading(
                                  indicator: BallSpinFadeLoaderIndicator(),
                                  size: 50.0,
                                  color: Colors.white),
                            ),
                          ); // your widget while loading
                        }

                        if (!snapshot.hasData) {
                          return Container(
                              height: MediaQuery.of(context).size.height - 300,
                              alignment: Alignment.center,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "Record Not Found",
                                    style: TextStyle(
                                        color: Colors.black54, fontSize: 20),
                                  ),
                                  Padding(padding: EdgeInsets.all(10)),
                                  Image.asset(
                                    'assets/images/not-found.png',
                                    width: 60,
                                  ),
                                ],
                              )); //your widget when error happens
                        }

                        final data = snapshot.data;
                        print(data.length);

                        return SingleChildScrollView(
                            child: Column(
                          children: <Widget>[
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: data.length,
                              itemBuilder: (context, index) {
                                var different;
                                // selectedStatus=='complete'?
                                // different=DateTime.parse(data[index]['OutTime']).difference(DateTime.parse(data[index]['InTime']))
                                // :
                                different=DateTime.parse(data[index]['EndTime']).difference(DateTime.parse(data[index]['StartTime']));
                                print(data);
                                return Container(
                                  margin: EdgeInsets.only(
                                      top: 10, bottom: 10, left: 10, right: 10),
                                  padding: EdgeInsets.all(20),
                                  color: Colors.white,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Expanded(
                                        flex: 4,
                                        child: Container(
                                          alignment: Alignment.topLeft,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.max,
                                            children: <Widget>[
                                              getNormalStringWidget(
                                                  "Reservation ID",
                                                  "${data[index]['Appointment_ID']}",
                                                  "black54"),
                                              Padding(
                                                  padding: EdgeInsets.all(1)),
                                              getNormalStringWidget(
                                                  "Car plate No.",
                                                  "${data[index]['CarPlateNumber']}",
                                                  "black54"),
                                              Padding(
                                                  padding: EdgeInsets.all(1)),
                                              selectedStatus == 'waiting' ||
                                                      selectedStatus ==
                                                          'confirmed' ||
                                                      selectedStatus == 'cancel'
                                                  ? new Container()
                                                  : getNormalStringWidget(
                                                      "Space ID",
                                                      "${data[index]['Space_ID']}",
                                                      "black54"),
                                              Padding(
                                                  padding: EdgeInsets.all(1)),
                                              selectedStatus=='complete'?
                                              getNormalStringWidget("In","${data[index]['InTime']}","black54") :
                                              getNormalStringWidget(
                                                  "Start",
                                                  "${data[index]['StartTime']}",
                                                  "black54"),
                                              Padding(
                                                  padding: EdgeInsets.all(1)),
                                              selectedStatus=='complete'?
                                              getNormalStringWidget("Out","${data[index]['OutTime']}","black54") :
                                              getNormalStringWidget(
                                                  "End",
                                                  "${data[index]['EndTime']}",
                                                  "black54"),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Container(
                                          alignment: Alignment.topRight,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              RichText(
                                                text: TextSpan(
                                                  text: "Status : ",
                                                  style: TextStyle(
                                                      color: Colors.black54,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                        text: '$selectedStatus',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.blue)),
                                                  ],
                                                ),
                                              ),
                                              RichText(
                                                text: TextSpan(
                                                  text: "Total: ",
                                                  style: TextStyle(
                                                      color: Colors.black54,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                        text: '${different.inHours}',
                                                        style: TextStyle(
                                                            color: Colors.blue,
                                                            fontSize: 25)),
                                                    TextSpan(
                                                        text: 'hrs',
                                                        style: TextStyle(
                                                            color: Colors.blue,
                                                            fontSize: 16)),
                                                  ],
                                                ),
                                              ),
                                              selectedStatus == 'waiting' ||
                                                      selectedStatus =='confirmed'
                                                  ? getCancelButton('${data[index]['Appointment_ID']}','${data[index]['StartTime']}','${data[index]['EndTime']}')
                                                  : new Container(),
                                              selectedStatus == 'cancel'
                                                  ? getDetailButton('${data[index]['Appointment_ID']}')
                                                  : new Container(),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            )
                          ],
                        ));
                      })
                ],
              ),
            )));
  }

  Widget getNormalStringWidget(name, value, color) {
    return RichText(
      text: TextSpan(
        text: "$name : ",
        style: TextStyle(color: Colors.black54, fontSize: 16),
        children: <TextSpan>[
          TextSpan(text: '$value', style: TextStyle(color: getColor(color))),
        ],
      ),
    );
  }

  Widget getCancelButton(appointmentID,startTime,endTime) {
    return Container(
      // alignment: Alignment.bottomRight,
      child: FlatButton(
        onPressed: () {

          setState(() {
            _confirmDialog(context,appointmentID,startTime,endTime);
          });
        },
        child: Text('Cancel',
            style: TextStyle(
              color: Colors.red,
              fontSize: 16,
            )),
        textColor: Colors.white,
        shape: RoundedRectangleBorder(
            side: BorderSide(
                color: Colors.red, width: 1, style: BorderStyle.solid),
            borderRadius: BorderRadius.circular(50)),
      ),
    );
  }

  Widget getDetailButton(appointmentID) {
    return Container(
      // alignment: Alignment.bottomRight,
      child: FlatButton(
        onPressed: () {
          setState(() {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => CanceldetailPage(appointmentID)));
          });
        },
        child: Text('Detail',
            style: TextStyle(
              color: Colors.blue,
              fontSize: 16,
            )),
        textColor: Colors.white,
        shape: RoundedRectangleBorder(
            side: BorderSide(
                color: Colors.blue, width: 1, style: BorderStyle.solid),
            borderRadius: BorderRadius.circular(50)),
      ),
    );
  }

  Color getColor(name) {
    Color color;
    switch (name) {
      case "red":
        color = Colors.red;
        break;
      case "black54":
        color = Colors.black54;
        break;
      case "blue":
        color = Colors.blue;
        break;
    }
    return color;
  }
}
