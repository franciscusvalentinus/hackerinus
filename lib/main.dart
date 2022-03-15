import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hackerinus/constant/RouteConstant.dart';
import 'package:hackerinus/screens/home/home_screen.dart';
import 'package:hackerinus/screens/login/login_screen.dart';
import 'package:hackerinus/screens/placeholder_widget.dart';
import 'package:hackerinus/utils/activity_util.dart';
import 'package:hackerinus/utils/sharedprefs_util.dart';
import 'package:shared_preferences/shared_preferences.dart';

final RouteConstant _routeConstant = new RouteConstant();

Future<void> main() async{


  runApp(HackerinusApp());
}

class HackerinusApp extends StatefulWidget{
  @override
  _HackerinusAppState createState() => _HackerinusAppState();

}

class _HackerinusAppState extends State<HackerinusApp> {
  bool statusLogin = false;

  Future<void> getPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      statusLogin = prefs.getBool('isLoggedIn') ?? false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getPrefs();
    print(statusLogin);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context,snapshot){
        if (snapshot.hasError) {
          print("has error");
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          print(ActivityUtils.dateNow());
          print("success flutter fire");
          return MaterialApp(
            theme: ThemeData( //2
                primaryColor: Colors.deepOrangeAccent,
                scaffoldBackgroundColor: Colors.white,
                fontFamily: 'Montserrat', //3
                buttonTheme: ButtonThemeData( // 4
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
                  buttonColor: Colors.redAccent,
                )
            ),
            debugShowCheckedModeBanner: false,
            initialRoute: statusLogin == true ? '/home' : '/login',
            routes: _routeConstant.routeList,
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return PlaceholderWidget(Colors.red);
      },
    );
  }
}
