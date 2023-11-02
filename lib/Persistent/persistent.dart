import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project/LoginPage/Services/global_variables.dart';

class Persistent{
  static List<String> jobCategoryList = [
    'Architecture and Construction',
    'Education and Training',
    'Development - Progamming',
    'Business',
    'Information',
    'Human Resources',
    'Design',
    'Acounting',
  ];
  static void getMyData() async{
    final DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('user').doc(FirebaseAuth.instance!.currentUser!.uid).get();
      name = userDoc.get('name');
      userImage = userDoc.get('userImage');
      location = userDoc.get('location');
  }
}