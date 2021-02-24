import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_first/homePage.dart';
import 'package:flutter_first/homepage1.dart';
import 'package:flutter_first/login/registerPage.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  _LoginCheckerPage createState() => _LoginCheckerPage();
}

class _LoginCheckerPage extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _keyRed = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  Future login() async {
     var url="http://192.168.1.143/flutter_FYP_php/login.php";
    //var url = "http://10.0.2.2/flutter_FYP_php/login.php";
    var response = await http.post(url, body: {
      "email": email.text,
      "password": password.text,
    });
    var data = json.decode(response.body);

    if (response.statusCode == 200) {
      if (data == "Success") {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.setString('email', email.text);

        Fluttertoast.showToast(
            msg: "Login Successful",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.blue,
            textColor: Colors.white,
            fontSize: 16.0);

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Homepage1()));
      } else {
        Fluttertoast.showToast(
            msg: "Email & Password Incorrect!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } else {
      Fluttertoast.showToast(
          msg: "A network error occurred",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  bool hirePassword = true;

  void initState() {
    hirePassword = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/Cutewallpaper.jpeg"),
                    fit: BoxFit.cover)),
            child: Scaffold(
                backgroundColor: Colors.transparent,
                body: SingleChildScrollView(
                    child: Padding(
                        padding: EdgeInsets.only(top: 10.0),
                        child: Column(
                          children: <Widget>[
                            Container(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 50, bottom: 10),
                                  child: Image.asset(
                                    "assets/images/splashLOGO.png",
                                    width: 400,
                                  ),
                                )),
                            getWidgetLoginCard(),
                            Container(
                                alignment: Alignment.bottomCenter,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 0, bottom: 0),
                                  child: Image.asset("assets/images/parkingLot.png",width: 400,),
                                )
                            ),
                          ],
                        ))))));
  }

  Widget getWidgetLoginCard() {
    return Padding(
      padding:
          const EdgeInsets.only(left: 16.0, right: 16.0, top: 20.0, bottom: 0),
      child: Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          elevation: 10.0,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    child: Text(
                      'LOGIN',
                      style: TextStyle(fontSize: 20.0, color: Colors.black),
                    ),
                  ),
                  Container(
                    child: TextFormField(
                      controller: email,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          labelText: 'Email',
                          icon: Icon(
                            Icons.email,
                            color: Colors.black38,
                          )),
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(top: 20.0),
                      child: TextFormField(
                        controller: password,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                        obscureText: hirePassword,
                        decoration: InputDecoration(
                            labelText: 'Password',
                            suffixIcon: IconButton(
                              icon: Icon(hirePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                              onPressed: () {
                                setState(() {
                                  hirePassword = !hirePassword;
                                });
                              },
                            ),
                            icon: Icon(
                              Icons.vpn_key,
                              color: Colors.black38,
                            )),
                      )),
                  Container(
                    margin: EdgeInsets.only(top: 20.0, bottom: 10),
                    width: double.infinity,
                    child: RaisedButton(
                      color: Colors.blueAccent,
                      textColor: Colors.white,
                      splashColor: Colors.black38,
                      elevation: 5.0,
                      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: Text(
                        'Login',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          login();
                        }
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10, bottom: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Not Yet Registered?'),
                        InkWell(
                            splashColor: Colors.black38,
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RegisterPage()));
                            },
                            child: Text('Register',
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold)))
                      ],
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }
}
