import 'package:flutter/material.dart';
import 'pages/home.dart';
import 'pages/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Provider/data_provider.dart';
import 'package:provider/provider.dart';

// Execution Starts
void main() {
  runApp(MyApp());
}

//--------------------------------------------
// MyApp Consists of two screens Login and Home
// State management used Provider
//--------------------------------------------

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MultiProvider(

      providers: [
        ChangeNotifierProvider(
          create: (context) => DataProvider(),
          child: Home(),
        ),
      ],

      child: MaterialApp(
        routes: {

          //Initial route

          '/':(context) =>FutureBuilder(
          future: SharedPreferences.getInstance(),
          builder:
          (BuildContext context, AsyncSnapshot<SharedPreferences> prefs) {

            if (prefs.hasData) {
              print(prefs.data!.getBool('isloggedin') );
              if (prefs.data!.getBool('isloggedin') ?? false) {
                return Home();
              }
            }

            return Login();
          }
          ),


          // home and login routes
          '/home':(context) =>Home(),
          '/login':(context) =>Login(),
        },
      ),
    );
  }
}

