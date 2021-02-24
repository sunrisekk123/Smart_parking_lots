import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_button/flutter_button.dart';
import 'package:flutter_first/homepage1.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Myprofile extends StatefulWidget{
  @override
  _MyprofilePage createState() =>_MyprofilePage();
}

class _MyprofilePage extends State<Myprofile> {
  final _formKey = GlobalKey<FormState>();
  var email = "";
  var id="";
  int _currentIndex;
  TextEditingController lNameCon = TextEditingController();
  TextEditingController fNameCon = TextEditingController();
  TextEditingController emailCon = TextEditingController();
  TextEditingController passwordCon = TextEditingController();
  TextEditingController password2Con = TextEditingController();
  TextEditingController phoneNumCon = TextEditingController();
  TextEditingController memberTypeCon = TextEditingController();
  List record = [];

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

  Future<void> editProfile()async{
    var url="http://192.168.1.143/flutter_FYP_php/editProfile.php";
    //var url="http://10.0.2.2/flutter_FYP_php/editProfile.php";

    var response= await http.post(url,body:{
      "firstName" :fNameCon.text,
      "lastName": lNameCon.text,
      "phoneNum" : phoneNumCon.text,
      "memberType" : memberTypeCon.text,
      "id" : id,
    });
    var data=json.decode(response.body);

    if(data == "Success"){
      Fluttertoast.showToast(
          msg: "Edit  Successful",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          fontSize: 16.0
      );
      Navigator.push(context,MaterialPageRoute(builder: (context)=>Myprofile()));
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

  Future<void> showUserData() async{
    await getLoginEmail();
    await showProfile();
    await setUserData();
  }

  Future<void> setUserData() async{
    emailCon.text=email;
    id=record[0]['Member_ID'];
    fNameCon.text=record[0]['FirstName'];
    lNameCon.text=record[0]['LastName'];
    passwordCon.text=record[0]['Password'];
    phoneNumCon.text=record[0]['PhoneNumber'];
    memberTypeCon.text=record[0]['MemberType'];
    if(record[0]['MemberType']=='lecturer'){
      _currentIndex=0;
    }else if(record[0]['MemberType']=='guest'){
      _currentIndex=1;
    }
  }


  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return  AlertDialog(
            title: Text('Edit Password'),
            content: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child:Form(
                key: _editPwKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    onChanged: (value) {
                      setState(() {
                        boxOldPW= value;
                      });
                    },
                    validator: _validatelOldPw,
                    controller: _boxOldPwCon,
                    decoration: InputDecoration(hintText: "Old Password"),
                    obscureText: true,
                    autofocus:true,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,

                  ),
                  TextFormField(
                    onChanged: (value) {
                      setState(() {
                        boxNewPW1= value;
                      });
                    },
                    validator:_validatePassword,
                    controller: _boxNewPwCon1,
                    decoration: InputDecoration(hintText: "New Password"),
                    obscureText: true,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                  ),
                  TextFormField(
                    onChanged: (value) {
                      setState(() {
                        boxNewPW2= value;
                      });
                    },
                    validator:_validatePassword2,
                    controller: _boxNewPwCon2,
                    decoration: InputDecoration(hintText: "Comfirm Password"),
                    obscureText: true,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                  ),

                ],
              ),),
            ),
            actions: <Widget>[
              FlatButton(
                color: Colors.red,
                textColor: Colors.white,
                child: Text('CANCEL'),
                onPressed: () {
                  setState(() {
                    _boxNewPwCon1.text="";
                    _boxNewPwCon2.text="";
                    _boxOldPwCon.text="";
                    Navigator.pop(context);
                  });
                },
              ),
              FlatButton(
                color: Colors.green,
                textColor: Colors.white,
                child: Text('OK'),
                onPressed: ()  {
                    if(_editPwKey.currentState.validate()){
                        editPW();
                    }
                },
              ),
            ],
          );
        });
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
                    margin: EdgeInsets.only(top: 2.0,bottom:10),
                    padding: EdgeInsets.only(left: 20,top: 5,bottom: 5),
                    child: Text(
                      'My Profile ',
                      style: TextStyle(fontSize: 20.0, color: Colors.black54,fontWeight: FontWeight.bold),
                    ),
                    color: Colors.orange.withOpacity(0.1),
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    width: double.infinity,
                    margin: EdgeInsets.only(top: 2.0,bottom:10),
                    padding: EdgeInsets.only(left: 20,top: 5,bottom: 5),
                    child: Text(
                      'Member ID :$id',
                      style: TextStyle(fontSize: 20.0, color: Colors.black54,fontWeight: FontWeight.bold),
                    ),

                  ),



                  Container(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 15),
                        child: CircleAvatar(
                          radius: 55.0,
                          backgroundColor: Colors.brown.withOpacity(0.5),
                          child: ClipRRect(
                            borderRadius:BorderRadius.circular(53),
                            child: Image.asset('assets/images/icons/boy.png',width: 500,),
                          )

                        )
                      )
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
                       enabled: false,

                       controller: emailCon,
                       // validator: _validateEmail,
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

                   Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 7,
                                child:TextFormField(
                                  controller: passwordCon,
                                  validator: _validatePassword,
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.next,
                                  obscureText: true,
                                  enabled: false,
                                  decoration: InputDecoration(
                                      labelText: 'Password ',
                                      icon: Icon(
                                        Icons.vpn_key,
                                        color: Colors.black38,
                                      )),
                                ),),
                                Expanded(
                                  flex: 1,
                                child:IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    setState(() {
                                      _displayTextInputDialog(context);
                                    });
                                  },
                                ),

                                ),],
                            ),

                   Container(
                       child: TextFormField(
                         controller: phoneNumCon,
                         validator: _validatePhoneNum,
                         keyboardType: TextInputType.phone,
                         textInputAction: TextInputAction.next,
                         decoration: InputDecoration(
                             labelText: 'Phone Number',
                             icon: Icon(
                               Icons.local_phone,
                               color: Colors.black38,
                             )),
                       )),
                  Container(
                      margin: EdgeInsets.only(top: 0,bottom:0),
                      padding: EdgeInsets.only(top: 0,bottom: 0),
                      child: TextFormField(
                        controller: memberTypeCon,
                        validator: _validateType,
                        readOnly: true,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                            labelText: 'Member Type',
                            icon: Icon(
                              Icons.group,
                              color: Colors.black38,
                            )),
                          onTap: () {
                            setState(() {
                              _selectTypeDialog();
                            });
                          }
                      )),
                  Container(
                      // margin: EdgeInsets.only(top: 0,bottom:0),
                      // padding: EdgeInsets.only(top: 0,bottom: 0),
                      width: double.infinity,
                      height: 100,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(top: 0.0, bottom: 0.0,left: 10,right: 10),
                              child:FlatButton(
                                onPressed: (){
                                  Navigator.push(context,MaterialPageRoute(builder: (context)=>Homepage1()));
                                },
                                child: Text('Back', style: TextStyle(
                                  color: Colors.blue,fontSize: 16,
                                )
                                ),
                                textColor: Colors.white,
                                shape: RoundedRectangleBorder(side: BorderSide(
                                    color: Colors.blue,
                                    width: 1,
                                    style: BorderStyle.solid
                                ), borderRadius: BorderRadius.circular(50)),
                              ),),),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(top: 0.0, bottom: 0.0,left: 10,right: 10),
                              child:FlatButton(
                                onPressed: (){
                                  if(_formKey.currentState.validate()){
                                    editProfile();
                                  }

                                },
                                child: Text('Edit', style: TextStyle(
                                    color: Colors.blue,fontSize: 16,
                                )
                                ),
                                textColor: Colors.white,
                                shape: RoundedRectangleBorder(side: BorderSide(
                                    color: Colors.blue,
                                    width: 1,
                                    style: BorderStyle.solid
                                ), borderRadius: BorderRadius.circular(50)),
                              ),),
                          ) ],

                      )


                  )


                ],
              ))))
    );
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
    if(value.length < 5)
      return 'Minimum 5 characters required';
    else if (value!=_boxNewPwCon1.text)
      return "Password are not matching";
    return null;
  }

  String _validatePhoneNum(String value) {
    if (value.length != 8)
      return 'Phone number must be of 8 digits';
    else
      return null;
  }


  String _validatelOldPw(String value)  {
    if(value.length < 5)
      return 'Minimum 5 characters required';
    else if (value=='0')
      return "Wrong Old Password";
    return null;
  }

  String _validateType(String value)  {
    if(value=='lecturer'||value=='guest')
      return null;
    else
      return "Wrong Member Type";
  }

  Future<void> editPW()async{
    var url="http://192.168.1.143/flutter_FYP_php/checkOldPW.php";
    //var url="http://10.0.2.2/flutter_FYP_php/checkOldPW.php";

    var response= await http.post(url,body:{
      "id" : id,
      "oldPassword" : _boxOldPwCon.text,
      "newPassword":_boxNewPwCon1.text,
    });
    var data=json.decode(response.body);

    if(data == "NotFound"){
      Fluttertoast.showToast(
          msg: "Wrong Old Password",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          fontSize: 16.0);
    }else if (data=="Success"){
      Fluttertoast.showToast(
          msg: "Edit Password Successful",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          fontSize: 16.0);
      codeDialog = boxNewPW1;
      passwordCon.text=boxNewPW1;
      Navigator.pop(context);
    }else if (data=="Error"){
      Fluttertoast.showToast(
          msg: "New Password Can Not Same As Old",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    _boxNewPwCon1.text="";
    _boxNewPwCon2.text="";
    _boxOldPwCon.text="";
  }


  List<String> memberType = ['lecturer','guest'];
  Future<String> _selectTypeDialog() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState2) {
              return AlertDialog(
                title: Text('Select Member Type'),
                actions: <Widget>[
                  FlatButton(
                    onPressed: () {
                      Navigator.pop(context, null);
                    },
                    child: Text('CANCEL'),
                  ),
                  FlatButton(
                    onPressed: () {
                      memberTypeCon.text=memberType[_currentIndex];
                      Navigator.pop(context, memberType[_currentIndex]);
                    },
                    child: Text('OK'),
                  ),
                ],
                content: Container(
                  width: double.minPositive,
                  height: 300,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: memberType.length,
                    itemBuilder: (BuildContext context, int index) {
                      return RadioListTile(
                        value: index,
                        groupValue: _currentIndex,
                        title: Text(memberType[index]),
                        onChanged: (val) {
                          setState2(() {
                            _currentIndex = val;
                          });
                        },
                      );
                    },
                  ),
                ),
              );
            },
          );
        });
  }

}
