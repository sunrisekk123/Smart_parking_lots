import 'package:flutter/material.dart';
import 'package:flutter_first/login/login_page.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';

class RegisterPage extends StatefulWidget {
  @override
  _register createState() => _register();
}


enum MemberType { lecturer, guest }

class _register extends State<RegisterPage> {
  bool hirePassword = true;
  bool hirePassword2 = true;
  final _formKey = GlobalKey<FormState>();
  TextEditingController lNameCon = TextEditingController();
  TextEditingController fNameCon = TextEditingController();
  TextEditingController emailCon = TextEditingController();
  TextEditingController passwordCon = TextEditingController();
  TextEditingController password2Con = TextEditingController();
  TextEditingController phoneNumCon = TextEditingController();
  MemberType _type = MemberType.lecturer;


  Future register()async{
     var url="http://192.168.1.143/flutter_FYP_php/register.php";
    //var url="http://10.0.2.2/flutter_FYP_php/register.php";

    var response= await http.post(url,body:{
      "email" : emailCon.text,
      "password" : passwordCon.text,
      "firstName" :fNameCon.text,
      "lastName": lNameCon.text,
      "phoneNum" : phoneNumCon.text,
      "memberType" : _type.toString().split('.').last,
    });
    var data=json.decode(response.body);

    if(data == "Success"){
      Fluttertoast.showToast(
          msg: "Registration  Successful",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          fontSize: 16.0
      );
      Navigator.push(context,MaterialPageRoute(builder: (context)=>LoginPage()));
    }else{
      Fluttertoast.showToast(
          msg: data,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );

    }
  }

  void initState() {
    hirePassword = true;
    hirePassword2 = true;
    MemberType _type = MemberType.lecturer;
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(''),
          backgroundColor: Colors.white,
        ),
        body: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/Cutewallpaper.jpeg"),
                    fit: BoxFit.cover)),
            child: Scaffold(
                backgroundColor: Colors.transparent,
                body: SingleChildScrollView(
                    child: Padding(
                        padding: EdgeInsets.only(top: 0.0),
                        child: Column(
                          children: <Widget>[
                            getWidgetRegisterCard(),
                          ],
                        ))))));
  }

  Widget getWidgetRegisterCard() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 20.0),
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
                    margin: EdgeInsets.only(bottom: 20.0),
                    child: Text(
                      'REGISTRATION',
                      style: TextStyle(fontSize: 20.0, color: Colors.black),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                          child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 4,
                            child: TextFormField(
                              controller: fNameCon,
                              validator: _validatefName,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                  labelText: 'First Name',
                                  icon: Icon(
                                    Icons.person_outline_sharp,
                                    color: Colors.black38,
                                  )),
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: TextFormField(
                              controller: lNameCon,
                              validator: _validatelName,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                  labelText: 'Last Name',
                                  icon: Icon(
                                    Icons.person_pin,
                                    color: Colors.black38,
                                  )),
                            ),
                          )
                        ],
                      ))
                    ],
                  ),
                  Container(
                    child: TextFormField(
                      controller: emailCon,
                      validator: _validateEmail,
                      keyboardType: TextInputType.text,
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
                      child: TextFormField(
                    controller: passwordCon,
                    validator: _validatePassword,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
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
                      child: TextFormField(
                    controller: password2Con,
                    validator: _validatePassword2,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    obscureText: hirePassword2,
                    decoration: InputDecoration(
                        labelText: 'Confirm Password ',
                        suffixIcon: IconButton(
                          icon: Icon(hirePassword2
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () {
                            setState(() {
                              hirePassword2 = !hirePassword2;
                            });
                          },
                        ),
                        icon: Icon(
                          Icons.vpn_key,
                          color: Colors.black38,
                        )),
                  )),
                  Container(
                      child: TextFormField(
                    controller: phoneNumCon,
                    validator: _validatePhoneNum,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    obscureText: hirePassword,
                    decoration: InputDecoration(
                        labelText: 'Phone Number',
                        icon: Icon(
                          Icons.local_phone,
                          color: Colors.black38,
                        )),
                  )),
                  Column(children: <Widget>[
                    Padding(
                      padding: new EdgeInsets.all(10.0),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Wrap(
                        // alignment: TextAlign.left,
                        crossAxisAlignment: WrapCrossAlignment.start,
                        children: [
                          Icon(Icons.group, color: Colors.black38),
                          Text(
                            '  Member Type:',
                            style: new TextStyle(
                                fontSize: 20.0, color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                    ListTile(
                      title: const Text(
                        'Lecturer',
                        style: TextStyle(color: Colors.black54),
                      ),
                      leading: Radio(
                        value: MemberType.lecturer,
                        groupValue: _type,
                        onChanged: (MemberType value) {
                          setState(() {
                            _type = value;
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text(
                        'Guest',
                        style: TextStyle(color: Colors.black54),
                      ),
                      leading: Radio(
                        value: MemberType.guest,
                        groupValue: _type,
                        onChanged: (MemberType value) {
                          setState(() {
                            _type = value;
                          });
                        },
                      ),
                    )
                  ]),
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
                        'Register',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      onPressed: () {
                        if(_formKey.currentState.validate()){
                          register();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          )
          ),
    );
  }

  String _validatefName(String value) {
    return value.trim().isEmpty ? "Please Input First Name" : null;
  }

  String _validatelName(String value) {
    return value.trim().isEmpty ? "Please Input Last Name" : null;
  }

  String _validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Invalid Email';
    } else {
      return null;
    }
  }

  String _validatePassword(String value) {
    return value.length < 5 ? 'Minimum 5 characters required' : null;
  }

  String _validatePassword2(String value) {
    if(value.length < 5)
      return 'Minimum 5 characters required';
    else if (value!=passwordCon.text)
      return "Password are not matching";
    return null;
  }

  String _validatePhoneNum(String value) {
    if (value.length != 8)
      return 'Phone number must be of 8 digits';
    else
      return null;
  }

}
