import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/Jobs/jobs_screen.dart';

import 'LoginPage/login_screen.dart';

class UserState extends StatefulWidget {
  const UserState({super.key});

  @override
  State<UserState> createState() => _UserStateState();
}

class _UserStateState extends State<UserState> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx,userSnapshot){
          if(userSnapshot.data == null){
            print('User is not logged in yet');
            return Login();
          } else if (userSnapshot.hasData){
            print('user is already logged in yet');
            return JobScreen();
          }else if(userSnapshot.hasError){
            return Scaffold(
              body: Center(
                child: Text('An error has been occurred. Try again'),
              ),

            );
          }
          else if(userSnapshot.connectionState ==ConnectionState.waiting){
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          return Scaffold(
            body: Center(
              child: Text('Something went wrong'),
            ),
          );
    });
  }
}
