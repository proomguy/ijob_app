import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ijob_app/LoginPage/login_screen.dart';
import 'package:ijob_app/jobs/jobs_screen.dart';

class UserState extends StatelessWidget {
  const UserState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (ctx, userSnapshot){
        if(userSnapshot.data == null){
          print('User is not logged in yet');
          return const LoginScreen();
        }
        else if(userSnapshot.hasData){
          print("User is already logged in");
          return const JobScreen();
        }
        else if(userSnapshot.hasError){
          return const Scaffold(
            body: Center(
              child: Text(
                'An error has occured, Try again later'
              ),
            ),
          );
        }
        else if(userSnapshot.connectionState == ConnectionState.waiting){
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator()
            ),
          );
        }
        return const Scaffold(
          body: Center(
            child: Text(
              'Something Went wrong'
            ),
          ),
        );
      },
    );
  }
}
