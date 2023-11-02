import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project/LoginPage/login_screen.dart';
import 'package:project/user_state.dart';
import 'firebase_options.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initalization = Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initalization,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const MaterialApp(
              home: Scaffold(
                body: Center(
                  child: Text(
                    "iJob clone App is being initalized",
                    style: TextStyle(
                        color: Colors.cyan,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      fontFamily: 'Signatra',
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
                    "An error has been occurred",
                    style: TextStyle(
                        color: Colors.cyan,
                        fontSize: 40,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            );
          }
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'iJob Clone App',
            theme: ThemeData(
                scaffoldBackgroundColor: Colors.black,
                primarySwatch: Colors.blue
            ),
            home: UserState(),

          );
        });
  }
}
