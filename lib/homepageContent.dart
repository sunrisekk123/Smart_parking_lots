import 'package:flutter/material.dart';
import 'package:flutter_button/flutter_button.dart';
import 'package:flutter_first/OrderDetailed.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'goToParking.dart';
import 'reserveAppointmentCampus.dart';
import 'homepageContent.dart';

class HomepageContent extends StatelessWidget {
  final title = "Homepage";

  @override
  Widget build(BuildContext context) {
    return Container(
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
                        getWidgetList(context),
                        getWidgetHomeBtn(context),
                      ],
                    )))));

  }

  Widget getWidgetList(BuildContext context){
    return Container(
      child: Card(

        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.notification_important_outlined),
              title: RichText(
                text: TextSpan(
                  text: "Current Car Space: ",
                  style: TextStyle(color: Colors.black),
                  children: <TextSpan>[
                    TextSpan(text: 'AVAILABLE', style: TextStyle(color: Colors.green,fontStyle: FontStyle.italic,fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              trailing: Icon(Icons.keyboard_arrow_right),
              // onTap: () => _openDetailsPage(context),
            ),
            new ExpansionTile(
                leading: Icon(Icons.book),
                title: Text('Latest Appointment'),
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
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      //add some actions, icons...etc
                      new FlatButton(
                          onPressed: () {
                            _openDetailsPage(context);
                          },
                          child: new Text("View")),
                    ],
                  ),
                ]),
          ],
        ),
      ), );

  }


    Widget getWidgetHomeBtn(BuildContext context) {
      return Padding(
          padding: const EdgeInsets.only(
              left: 10.0, right: 10.0, top: 10.0, bottom: 0),
          child: Card(
            color: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            elevation: 10.0,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 20.0, bottom: 10),
                    width: double.infinity,


                    child: RaisedButton(
                      color: Colors.white,
                      splashColor: Colors.grey,
                      elevation: 10.0,

                      padding: EdgeInsets.only(top: 0.0, bottom: 0.0,left: 0,right: 0),
                      

                      child: Container(
                          width: double.infinity,
                          margin: EdgeInsets.all(0),
                        padding: EdgeInsets.only(top: 10.0, bottom: 10.0,left: 0,right: 0),

                        decoration: new BoxDecoration(
                              gradient: new LinearGradient(
                                colors: [
                                  Color.fromRGBO(227, 239, 255, 1),
                                  // Color.fromRGBO(255, 255, 255, 1),
                                  Color.fromRGBO(255, 228, 240, 1)
                                ],
                              ),
                              borderRadius: new BorderRadius.all(const Radius.circular(30.0)),

                          ),
                      child: Column( // Replace with a Row for horizontal icon + text
                        children: <Widget>[
                          GlowText(
                            'Go To Parking',
                            style: TextStyle(
                                fontSize: 20, color: Colors.blueGrey,fontStyle:FontStyle.italic ),),
                          Container(
                            child: new Image.asset('assets/images/destination.png',width: 60,),
                          )
                        ],

                      ),),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                        onPressed: (){
                          Navigator.push(context,MaterialPageRoute(builder: (context)=>GoToParking()));
                        }
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(top: 20.0, bottom: 10),
                      width: double.infinity,
                      height: 200,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(top: 0.0, bottom: 0.0,left: 10,right: 10),
                              child: RaisedButton(
                                padding: EdgeInsets.only(top: 0.0, bottom: 0.0,left: 0,right: 0),
                                color: Colors.white,
                                splashColor: Colors.grey,
                                elevation: 10.0,

                                child: Container(
                                  width: double.infinity,
                                  margin: EdgeInsets.all(0),


                                  decoration: new BoxDecoration(
                                    gradient: new LinearGradient(
                                      colors: [
                                        Color.fromRGBO(224, 253, 255, 1),
                                        Color.fromRGBO(255, 255, 255, 1),
                                        Color.fromRGBO(255, 255, 255, 1),
                                        Color.fromRGBO(255, 236, 230, 1)
                                      ],
                                    ),
                                    borderRadius: new BorderRadius.all(const Radius.circular(10.0)),

                                  ),

                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,// Replace with a Row for horizontal icon + text
                                  children: <Widget>[

                                    GlowText(
                                      'Find My Car',
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.blueGrey,fontStyle:FontStyle.italic ),),
                                    Container(
                                      child: new Image.asset('assets/images/search.png',width: 70,),
                                    )
                                  ],
                                ),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                onPressed: () {
                                  Navigator.push(context,MaterialPageRoute(builder: (context)=>OrderDetailed()));
                                },
                                 ),),),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(top: 0.0, bottom: 0.0,left: 10,right: 10),
                              child: RaisedButton(
                                color: Colors.white,
                                splashColor: Colors.grey,
                                elevation: 10.0,
                                padding: EdgeInsets.only(top: 0.0, bottom: 0.0),
                                child: Container(
                                  width: double.infinity,
                                  margin: EdgeInsets.all(0),


                                  decoration: new BoxDecoration(
                                    gradient: new LinearGradient(
                                      colors: [

                                        Color.fromRGBO(255, 233, 236, 1),
                                        Color.fromRGBO(255, 255, 255, 1),
                                        // Color.fromRGBO(255, 255, 255, 1),
                                          Color.fromRGBO(227, 239, 255, 1)


                                      ],
                                    ),
                                    borderRadius: new BorderRadius.all(const Radius.circular(10.0)),

                                  ),

                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,// Repla// Replace with a Row for horizontal icon + text
                                  children: <Widget>[
                                    GlowText(
                                      'Reserve a Space',
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.blueGrey,fontStyle:FontStyle.italic ),),

                                    Container(
                                      child: new Image.asset('assets/images/booking.png',width: 70,),
                                    )
                                  ],

                                ),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ) ,
                                onPressed: () {
                                  Navigator.push(context,MaterialPageRoute(builder: (context)=>ReserveAppointmentCampus()));
                                },
                              ),),
                          ) ],

                      )


                  )
                ],
              ),

            ),
          )

      );
    }


  _openDetailsPage(BuildContext context) => Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => DetailsPage(title)));
}

class DetailsPage extends StatelessWidget {
  final String title;

  const DetailsPage(this.title) : assert(title != null);

  @override
  Widget build(BuildContext context) {
    final text = Text('Details of $title');
    return Scaffold(
      body: Container(
        child: Center(child: text),
      ),
      appBar: AppBar(title: text),
    );
  }
}
