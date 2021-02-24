import 'package:flutter/material.dart';
import 'package:flutter_first/goToParking.dart';
import 'package:flutter_first/homepage1.dart';
import 'package:flutter_first/login/login_page.dart';
import 'package:flutter_first/splash_page.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget{
  @override
  _home createState() =>_home();
}

  class _home extends State<HomePage>{

  var email="";

  Future getLoginEmail()async{
    SharedPreferences preferences=await SharedPreferences.getInstance();
    setState(() {
      email=preferences.getString('email');
    });
  }

  void initState(){
    super.initState();
    getLoginEmail();
  }


  Future logout(BuildContext context) async{
    SharedPreferences preferences=await SharedPreferences.getInstance();
    preferences.remove('email');
    Fluttertoast.showToast(
        msg: "Logout  Successful",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
        fontSize: 16.0
    );
    Navigator.push(context, MaterialPageRoute(builder: (context)=>SplashPage(),),);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dashboard'),automaticallyImplyLeading: false,),
      body:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Center(child: email=='' ? Text('Error') : Text(email)),
          SizedBox(height: 20,),

          MaterialButton(
              color:Colors.grey,
              onPressed: (){
            logout(context);
          },child: Text("log out",style:TextStyle(color: Colors.white),),),
          MaterialButton(
            color:Colors.grey,
            onPressed: (){
              Navigator.push(context,MaterialPageRoute(builder: (context)=>GoToParking()));
            },child: Text("Map",style:TextStyle(color: Colors.white),),),
          MaterialButton(
            color:Colors.grey,
            onPressed: (){
              Navigator.push(context,MaterialPageRoute(builder: (context)=>Homepage1()));
            },child: Text("Home",style:TextStyle(color: Colors.white),),)
        ],
      )
    );
  }

  }



