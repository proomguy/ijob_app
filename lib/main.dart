import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'LoginPage/login_screen.dart';

void main() {

  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());

}

class MyApp extends StatelessWidget {

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot){
        if(snapshot.connectionState == ConnectionState.waiting){
          return const MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text(
                  "iJOB App is being initialized",
                  style: TextStyle(
                    color: Colors.cyan,
                    fontSize: 38,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Signatra'
                  ),
                ),
              ),
            ),
          );
        }
        else if(snapshot.hasError){
          return const MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text(
                  "An error has occurred during initializing process",
                  style: TextStyle(
                      color: Colors.cyan,
                      fontSize: 40,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),
          );
        }
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "IJOB App",
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.black,
            primarySwatch: Colors.lightBlue
          ),
          home: const LoginScreen(),
        );
      }
    );
  }
}

