import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flare_splash_screen/flare_splash_screen.dart';
import 'package:flutter/services.dart';
import 'package:flutter_first/homePage.dart';
import 'package:flutter_first/homepage1.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login/login_page.dart';
import 'package:rive/rive.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  void _togglePlay() {
    setState(() => _controller.isActive = !_controller.isActive);
  }

  /// Tracks if the animation is playing by whether controller is running.
  bool get isPlaying => _controller?.isActive ?? false;

  Artboard _riveArtboard;
  RiveAnimationController _controller;

  @override
  void initState() {
    super.initState();

    // Load the animation file from the bundle, note that you could also
    // download this. The RiveFile just expects a list of bytes.
    rootBundle.load('assets/car.riv').then(
          (data) async {
        final file = RiveFile();

        // Load the RiveFile from the binary data.
        if (file.import(data)) {
          // The artboard is the root of the animation and gets drawn in the
          // Rive widget.
          final artboard = file.mainArtboard;
          // Add a controller to play back a known animation on the main/default
          // artboard.We store a reference to it so we can toggle playback.
          artboard.addController(_controller = SimpleAnimation('Untitled 1'));
          setState(() => _riveArtboard = artboard);
        }
      },
    );
    new Future.delayed(
        const Duration(seconds: 2),
            () =>navigateUser(),
            );
  }

  void navigateUser () async{
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences preferences= await SharedPreferences.getInstance();
    var email = preferences.getString('email');
    if(email==null){
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),);
    }else{
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => Homepage1()),);
    }
  }

  /// Show the rive file, when loaded
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor("4D4848"),
      body: Center(


        child: _riveArtboard == null
            ? const SizedBox()
            : Rive(artboard: _riveArtboard),
      ),

      /*floatingActionButton: FloatingActionButton(
        onPressed: _togglePlay,
        tooltip: isPlaying ? 'Pause' : 'Play',
        child: Icon(
          isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),*/
    );
  }

/*
  @override
  Widget build(BuildContext context) {
    return SplashScreen.navigate(
      name: 'assets/test.flr', // flr動畫檔路徑
      next: (context)=>LoginPage(), // 動畫結束後轉換頁面
      until: () => Future.delayed(Duration(seconds: 3)), //等待3秒
      startAnimation: 'test', // 動畫名稱
    );
  }
}
*/
}
class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
