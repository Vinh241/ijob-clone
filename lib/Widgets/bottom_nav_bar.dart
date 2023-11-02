import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/Jobs/jobs_screen.dart';
import 'package:project/Jobs/upload_job.dart';
import 'package:project/Search/profile_company.dart';
import 'package:project/Search/search_companies.dart';
import 'package:project/user_state.dart';

class BottomNavigationBarForApp extends StatelessWidget {
  final int indexNum;

  const BottomNavigationBarForApp({super.key, required this.indexNum});

  void _logout(context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.black54,
            title: Row(
              children: const [
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Icon(
                    Icons.logout,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    'Sign out',
                    style: TextStyle(color: Colors.white, fontSize: 28),
                  ),
                )
              ],
            ),
            content: const Text(
              'Do you want to log out',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).canPop()
                        ? Navigator.of(context).pop()
                        : null;
                  },
                  child: const Text(
                    'No',
                    style: TextStyle(color: Colors.green, fontSize: 18),
                  )),
              TextButton(
                  onPressed: () {
                    _auth.signOut();
                    Navigator.of(context).canPop()
                        ? Navigator.of(context).pop()
                        : null;
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=>UserState()));
                  },
                  child: const Text(
                    'Yes',
                    style: TextStyle(color: Colors.green, fontSize: 18),
                  ))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      color: Colors.deepOrange.shade400,
      backgroundColor: Colors.blueAccent,
      buttonBackgroundColor: Colors.deepOrange.shade300,
      height: 50,
      index: indexNum,
      items: [
        Icon(Icons.list, size: 19, color: Colors.black),
        Icon(
          Icons.search,
          size: 19,
          color: Colors.black,
        ),
        Icon(
          Icons.add,
          size: 19,
          color: Colors.black,
        ),
        Icon(
          Icons.person_pin,
          size: 19,
          color: Colors.black,
        ),
        Icon(
          Icons.exit_to_app,
          size: 19,
          color: Colors.black,
        ),
      ],
      animationDuration: Duration(milliseconds: 300),
      animationCurve: Curves.bounceInOut,
      onTap: (index) {
        if (index == 0) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => JobScreen()));
        } else if (index == 1) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => AllWorkersScreen()));
        } else if (index == 2) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => UploadJobNow()));
        } else if (index == 3) {
          final FirebaseAuth _auth = FirebaseAuth.instance;
          final User? user = _auth.currentUser;
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => ProfileScreen(userId: user!.uid)));
        } else if (index == 4) {
          _logout(context);
        }
      },
    );
  }
}
