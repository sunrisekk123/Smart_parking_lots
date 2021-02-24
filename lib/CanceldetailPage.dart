import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class CanceldetailPage extends StatefulWidget{
  String appointmentID;
  CanceldetailPage(this.appointmentID);

  _CancelDetail createState() => _CancelDetail(appointmentID);
}

class _CancelDetail extends State<CanceldetailPage> {
  String appointmentID;
  List record = [];
  _CancelDetail(this.appointmentID);
  String cancelOrderID,staffID,cancelDate,status;


 void initState(){
   super.initState();
   showBookingData();
 }


  Future<void> showBookingData() async{
    await showCancelOrder();
    await setCancelOrderData();
  }

  Future showCancelOrder() async {
    var url="http://192.168.1.143/flutter_FYP_php/showCancelOrder.php";
    //var url = "http://10.0.2.2/flutter_FYP_php/showCancelOrder.php";
    var response = await http.post(url, body: {
      "appointmentID": appointmentID,
    });
    var data = json.decode(response.body);

    if (response.statusCode == 200) {
      if (data == "error") {
        Fluttertoast.showToast(
            msg: "Data not found ",
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

  Future<void> setCancelOrderData() async{
    cancelOrderID=record[0]['CancelOrder_ID'];
    staffID=record[0]['Staff_ID'];
    cancelDate=record[0]['Cancel_date'];
    status=record[0]['Status'];


  }

  @override
  Widget build(BuildContext context) {
   return Scaffold(
     backgroundColor: Colors.blue[50],
     appBar: AppBar(

       title: Row(
           mainAxisAlignment: MainAxisAlignment.start,
           children: [
             Image.asset(
               'assets/images/barLogo.png',
               fit: BoxFit.contain,
               height: 40,
             ),
           ]),
       backgroundColor: Colors.white,
     ),
     body: Container(
       child: Column(
         children: <Widget>[
           Container(
             alignment: Alignment.topLeft,
             width: double.infinity,
             margin: EdgeInsets.only(top: 2.0,bottom:2),
             padding: EdgeInsets.only(left: 20,top: 5,bottom: 5),
             child: Text(
               'Cancel Order Details ',
               style: TextStyle(fontSize: 22.0, color: Colors.black54,fontWeight: FontWeight.bold),
             ),
             color: Colors.orange[50]
           ),
           Container(

             margin: EdgeInsets.only(top: 20,bottom: 50),
             padding: EdgeInsets.only(top: 30,bottom: 30,left: 20),
             color: Colors.white,
             alignment: Alignment.centerLeft,

             child:Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: <Widget>[
                 getNormalStringWidget("Cancel Order ID","$cancelOrderID"),
                 getNormalStringWidget("Reservation ID","$appointmentID"),
                 getNormalStringWidget("Cancel Date","$cancelDate"),
                 staffID==null? Container() : getNormalStringWidget("Staff ID","$staffID"),
                 getNormalStringWidget("Status","$status"),
               ],
             ),
           ),

         ],
       ),
     ),
   );
  }

  Widget getNormalStringWidget(name, value) {
    return Container(
      margin: EdgeInsets.all(2),
    
      child:RichText(
      text: TextSpan(
        text: "$name : ",
        style: TextStyle(color: Colors.black54, fontSize: 18),
        children: <TextSpan>[
          TextSpan(text: '$value', style: TextStyle(color: Colors.black54)),
        ],
      ),
    ));
  }

}