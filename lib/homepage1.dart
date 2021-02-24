import 'package:flutter/material.dart';
import 'package:flutter_first/MyReservation.dart';
import 'PlaceholderWidget.dart';
import 'homepageContent.dart';
import 'drawer/drawerList.dart';

class Homepage1 extends StatefulWidget {
  Homepage1({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Homepage1> {
  int _currentIndex = 0;
  TabController _tabController;
  final List<Widget> _children = [
    HomepageContent(),
    MyReservation(),
    PlaceholderWidget(Colors.green)
  ];

  final List<Widget> _button=[
      IconButton(
        icon: Icon(Icons.qr_code_rounded ),
        onPressed: (){},
      )
    , IconButton(
      icon: Icon(Icons.search ),
      onPressed: null,
    ),
    IconButton(
      icon: Icon(Icons. search),
      onPressed: null,
    )

  ];



  void initState() {
    super.initState();
  }




  @override
  Widget build(BuildContext context) {
    return  Scaffold(
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
        actions:<Widget>[_button[_currentIndex]] ,

        backgroundColor: Colors.white,
      ),
      drawer: Drawer(child: DrawerList()),
      body:_children[_currentIndex],
      // body: _children[_currentIndex],


      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.home),
            title: new Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.sticky_note_2),
            title: new Text('My Reservation'),
          ),
          BottomNavigationBarItem(icon: Icon(Icons.map), title: Text('History'))
        ],
      ),
        );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

}

