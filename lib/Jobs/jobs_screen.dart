import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project/LoginPage/Services/global_method.dart';
import 'package:project/Search/search_job.dart';
import 'package:project/Widgets/bottom_nav_bar.dart';
import 'package:project/Widgets/job_widget.dart';

import '../Persistent/persistent.dart';

class JobScreen extends StatefulWidget {
  const JobScreen({super.key});

  @override
  State<JobScreen> createState() => _JobScreenState();
}

class _JobScreenState extends State<JobScreen> {
  String? jobCategoryFilter;
  @override
  void initState() {
    // TODO: implement initState
    Persistent.getMyData();
    super.initState();
  }
  final FirebaseAuth _auth = FirebaseAuth.instance;

  _showTaskCategoryDialog({required Size size}) {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            backgroundColor: Colors.black54,
            title: Text(
              'Job category',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            content: Container(
              width: size.width * 0.9,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: Persistent.jobCategoryList.length,
                itemBuilder: (ctx, index) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        jobCategoryFilter = Persistent.jobCategoryList[index];
                      });
                      Navigator.of(context).canPop()
                          ? Navigator.of(context).pop()
                          : null;
                      print(
                          'jobCategoryList[index], ${Persistent.jobCategoryList[index]}');
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.arrow_right_alt_outlined,
                          color: Colors.grey,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            Persistent.jobCategoryList[index],
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).canPop()
                        ? Navigator.of(context).pop()
                        : null;
                  },
                  child: Text(
                    'Close',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  )),
              TextButton(
                  onPressed: () {
                    setState(() {
                      jobCategoryFilter = null;
                    });
                    Navigator.canPop(context) ? Navigator.pop(context) : null;
                  },
                  child: Text(
                    "Cancel Filter",
                    style: TextStyle(color: Colors.white),
                  ))
            ],
          );
        });
  }

   _deleteDialog({required String uploadedBy,required String id}) {
    User? user = _auth.currentUser;
    final _uid = user!.uid;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Are you sure to delete? '),
            actions: [
              TextButton(
                onPressed: () async {
                  try {
                    if (uploadedBy == _uid) {
                      await FirebaseFirestore.instance
                          .collection('jobs')
                          .doc(id)
                          .delete();
                      await Fluttertoast.showToast(
                          msg: 'Job has been deleted',
                          toastLength: Toast.LENGTH_LONG,
                          backgroundColor: Colors.grey,
                          fontSize: 18);
                      Navigator.canPop(context) ? Navigator.of(context).pop(true): null;
                    }else{
                      GlobalMethod.showErrorDialog(error: "You cannot perform this actions", ctx: context);
                    }

                  } catch (error) {
                    GlobalMethod.showErrorDialog(error: 'This task cannot be deleted', ctx: context);
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    Text(
                      'Delete',
                      style: TextStyle(color: Colors.red),
                    )
                  ],
                ),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.deepOrange.shade300, Colors.blueAccent],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              stops: [0.2, 0.9])),
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBarForApp(indexNum: 0),
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.deepOrange.shade300, Colors.blueAccent],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    stops: [0.2, 0.9])),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.filter_list_rounded,
              color: Colors.black,
            ),
            onPressed: () {
              _showTaskCategoryDialog(size: MediaQuery.of(context).size);
            },
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => SearchScreen()));
                },
                icon: Icon(
                  Icons.search_outlined,
                  color: Colors.black,
                ))
          ],
        ),
        body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('jobs')
              .where('jobCategory', isEqualTo: jobCategoryFilter)
              .where('recruitment', isEqualTo: true)
              .orderBy('createdAt', descending: false)
              .snapshots(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.data?.docs.isNotEmpty == true) {
                return ListView.builder(
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (context, index) {
                    final item = snapshot.data.docs[index]['id'];
                    return Dismissible(
                      key:Key(item),
                      background: Container(
                        margin: EdgeInsets.symmetric(vertical: 8,horizontal: 8),
                        color: Colors.red,
                        child: Icon(Icons.delete,color: Colors.white,
                        size: 30,),
                      ),
                      confirmDismiss: (direction) async {
                          return await _deleteDialog(uploadedBy: snapshot.data.docs[index]['uploadedBy'] , id:  snapshot.data.docs[index]['id']);
                      },
                      child: JobWidget(
                        jobTitle: snapshot.data.docs[index]['jobTitle'],
                        email: snapshot.data.docs[index]['email'],
                        jobDescription: snapshot.data.docs[index]
                            ['jobDescription'],
                        jobId: snapshot.data.docs[index]['id'],
                        location: snapshot.data.docs[index]['location'],
                        name: snapshot.data.docs[index]['name'],
                        recruitment: snapshot.data.docs[index]['recruitment'],
                        uploadedBy: snapshot.data.docs[index]['uploadedBy'],
                        userImage: snapshot.data.docs[index]['userImage'],
                      ),
                    );
                  },
                );
              } else {
                return Center(
                  child: Text('There is no jobs'),
                );
              }

            }
            return Center(
              child: Text(
                'Something went wrong',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
