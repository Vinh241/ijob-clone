import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project/Jobs/jobs_screen.dart';
import 'package:project/LoginPage/Services/global_method.dart';
import 'package:project/LoginPage/Services/global_variables.dart';
import 'package:project/Widgets/comments_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:uuid/uuid.dart';

class JobDetailScreen extends StatefulWidget {
  final String uploadedBy;
  final String jobID;

  const JobDetailScreen(
      {super.key, required this.jobID, required this.uploadedBy});

  @override
  State<JobDetailScreen> createState() => _JobDetailScreenState();
}

class _JobDetailScreenState extends State<JobDetailScreen> {
  final TextEditingController _commentController = TextEditingController();
  bool _isCommenting = false;
  String? authorName;
  String? userImageUrl;
  String? jobCategory;
  String? jobDescription;
  String? jobTitle;
  bool? recruitment;
  Timestamp? postedDateTimeStamp;
  Timestamp? deadlineDateTimeStamp;
  String? postedDate;
  String? deadlineDate;
  String? locationCompany = '';
  String? emailCompany = '';
  int applicants = 0;
  bool isDeadlineAvailabel = false;
  bool showComment = false;

  void getJobData() async {
    final DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('user')
        .doc(widget.uploadedBy)
        .get();
    if (userDoc == null) {
      return;
    }
    setState(() {
      authorName = userDoc.get('name');
      userImageUrl = userDoc.get('userImage');
    });
    final DocumentSnapshot jobDatabase = await FirebaseFirestore.instance
        .collection('jobs')
        .doc(widget.jobID)
        .get();
    if (jobDatabase == null) {
      return;
    }
    setState(() {
      jobTitle = jobDatabase.get('jobTitle');
      jobDescription = jobDatabase.get("jobDescription");
      recruitment = jobDatabase.get('recruitment');
      emailCompany = jobDatabase.get('email');
      locationCompany = jobDatabase.get('location');
      applicants = jobDatabase.get('applicant');
      postedDateTimeStamp = jobDatabase.get('createdAt');
      deadlineDateTimeStamp = jobDatabase.get('deadlineDataTimeStamp');
      deadlineDate = jobDatabase.get('deadlineDate');
      var postDate = postedDateTimeStamp!.toDate();
      postedDate = '${postDate.day} - ${postDate.month} - ${postDate.year}';
    });
    var date = deadlineDateTimeStamp!.toDate();
    isDeadlineAvailabel = date.isAfter(DateTime.now());
  }

  @override
  void initState() {
    // TODO: implement initState
    getJobData();
    super.initState();
  }

  Widget dividerWidget() {
    return Column(
      children: const [
        SizedBox(
          height: 10,
        ),
        Divider(
          thickness: 1,
          color: Colors.grey,
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }

  applyForJob() {
    final Uri params = Uri(
      scheme: 'mailto',
      path: emailCompany,
      query:
      'subject=Applying for $jobTitle&body=Hello, please attach Resume CV file',
    );
    final url = params.toString();
    launchUrlString(url);
    addNewApplicant();
  }

  void addNewApplicant() async {
    var docRef =
    FirebaseFirestore.instance.collection('jobs').doc(widget.jobID);
    await docRef.update({'applicant': applicants + 1});
    DocumentSnapshot data = await FirebaseFirestore.instance
        .collection('jobs')
        .doc(widget.jobID)
        .get();
    setState(() {
      applicants = data.get('applicant');
    });
    // Navigator.of(context).pop();
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
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.deepOrange.shade300, Colors.blueAccent],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    stops: [0.2, 0.9])),
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.close,
              size: 40,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => JobScreen()));
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(4),
                child: Card(
                  color: Colors.black54,
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 4),
                          child: Text(
                            jobTitle ?? '',
                            maxLines: 3,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                  border:
                                  Border.all(width: 3, color: Colors.grey),
                                  shape: BoxShape.rectangle,
                                  image: DecorationImage(
                                      image: NetworkImage(
                                        userImageUrl ??
                                            'https://th.bing.com/th/id/OIP.U096knBymS0Oz-4PAvxH7AHaHa?pid=ImgDet&rs=1',
                                      ),
                                      fit: BoxFit.fill)),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    authorName ?? '',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.white),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    locationCompany ?? "",
                                    style: TextStyle(color: Colors.grey),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        dividerWidget(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              applicants.toString(),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                            const SizedBox(
                              width: 6,
                            ),
                            const Text(
                              'Applicants',
                              style: TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Icon(
                              Icons.how_to_reg_sharp,
                              color: Colors.grey,
                            )
                          ],
                        ),
                        FirebaseAuth.instance.currentUser!.uid !=
                            widget.uploadedBy
                            ? Container()
                            : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            dividerWidget(),
                            const Text(
                              'Recruitment',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    User? user =
                                        FirebaseAuth.instance.currentUser;
                                    final _uid = user!.uid;
                                    if (_uid == widget.uploadedBy) {
                                      try {
                                        FirebaseFirestore.instance
                                            .collection('jobs')
                                            .doc(widget.jobID)
                                            .update(
                                            {'recruitment': true});
                                      } catch (error) {
                                        GlobalMethod.showErrorDialog(
                                            error:
                                            'Action cannot be perform',
                                            ctx: context);
                                      }
                                    } else {
                                      GlobalMethod.showErrorDialog(
                                          error:
                                          "You cannot perform this action",
                                          ctx: context);
                                    }
                                    setState(() {
                                      recruitment = true;
                                    });
                                  },
                                  child: const Text(
                                    "ON",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontStyle: FontStyle.italic,
                                        color: Colors.black),
                                  ),
                                ),
                                Opacity(
                                  opacity: recruitment == true ? 1 : 0,
                                  child: const Icon(
                                    Icons.check_box,
                                    color: Colors.green,
                                  ),
                                ),
                                SizedBox(
                                  width: 40,
                                ),
                                TextButton(
                                  onPressed: () {
                                    User? user =
                                        FirebaseAuth.instance.currentUser;
                                    final _uid = user!.uid;
                                    if (_uid == widget.uploadedBy) {
                                      try {
                                        FirebaseFirestore.instance
                                            .collection('jobs')
                                            .doc(widget.jobID)
                                            .update(
                                            {'recruitment': false});
                                      } catch (error) {
                                        GlobalMethod.showErrorDialog(
                                            error:
                                            'Action cannot be perform',
                                            ctx: context);
                                      }
                                    } else {
                                      GlobalMethod.showErrorDialog(
                                          error:
                                          "You cannot perform this action",
                                          ctx: context);
                                    }
                                    setState(() {
                                      recruitment = false;
                                    });
                                  },
                                  child: const Text(
                                    "OFF",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontStyle: FontStyle.italic,
                                        color: Colors.black),
                                  ),
                                ),
                                Opacity(
                                  opacity: recruitment == false ? 1 : 0,
                                  child: const Icon(
                                    Icons.check_box,
                                    color: Colors.red,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                        dividerWidget(),
                        const Text(
                          'Job Description',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          jobDescription ?? '',
                          style: const TextStyle(color: Colors.white),
                          textAlign: TextAlign.justify,
                        ),
                        dividerWidget()
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(4),
                child: Card(
                  color: Colors.black54,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: Text(
                            isDeadlineAvailabel
                                ? "Actively Recruiting, Send CV/Resume:"
                                : 'Deadline Passed away',
                            style: TextStyle(
                                color: isDeadlineAvailabel
                                    ? Colors.green
                                    : Colors.red,
                                fontWeight: FontWeight.normal,
                                fontSize: 16),
                          ),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Center(
                          child: MaterialButton(
                            onPressed: () {
                              applyForJob();
                            },
                            color: Colors.blueAccent,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(13)),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 14),
                              child: Text(
                                'Easy Apply Now',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14),
                              ),
                            ),
                          ),
                        ),
                        dividerWidget(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Uploaded on:',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              postedDate ?? '',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Deadline date:',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              deadlineDate ?? '',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            )
                          ],
                        ),
                        dividerWidget()
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(4.0),
                child: Card(
                  color: Colors.black54,
                  child: Padding(
                    padding: EdgeInsets.all(4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AnimatedSwitcher(
                          duration: Duration(milliseconds: 500),
                          child: _isCommenting
                              ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                flex: 3,
                                child: TextField(
                                  controller: _commentController,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                  maxLength: 200,
                                  keyboardType: TextInputType.text,
                                  maxLines: 6,
                                  decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Theme
                                          .of(context)
                                          .scaffoldBackgroundColor,
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.white)),
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.pink)),
                                      errorBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.red))),
                                ),
                              ),
                              Flexible(
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8),
                                        child: MaterialButton(
                                          onPressed: () async {
                                            if (_commentController
                                                .text.length <
                                                7) {
                                              GlobalMethod.showErrorDialog(
                                                  error:
                                                  "Comment cannot be less than 7",
                                                  ctx: context);
                                            } else {
                                              final _generated =
                                              const Uuid().v4();
                                              await FirebaseFirestore.instance
                                                  .collection('jobs')
                                                  .doc(widget.jobID)
                                                  .update({
                                                'jobComments':
                                                FieldValue.arrayUnion([
                                                  {
                                                    'userId': FirebaseAuth
                                                        .instance
                                                        .currentUser!
                                                        .uid,
                                                    'commentId': _generated,
                                                    'name': name,
                                                    'userImageUrl':
                                                    userImage ,
                                                    'commentBody':
                                                    _commentController
                                                        .text,
                                                    'time': Timestamp.now(),
                                                  }
                                                ])
                                              });
                                              await Fluttertoast.showToast(
                                                  msg:
                                                  'Your comment has been added',
                                                  toastLength:
                                                  Toast.LENGTH_LONG,
                                                  backgroundColor:
                                                  Colors.grey,
                                                  fontSize: 18);
                                              _commentController.clear();
                                            }
                                            setState(() {
                                              showComment = true;
                                            });
                                            FocusManager.instance.primaryFocus
                                                ?.unfocus();
                                          },
                                          color: Colors.blueAccent,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(13),
                                          ),
                                          child: Text(
                                            'Post',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14),
                                          ),
                                        ),
                                      ),
                                      TextButton(
                                          onPressed: () {
                                            setState(() {
                                              _isCommenting = !_isCommenting;
                                              showComment = false;
                                            });
                                          },
                                          child: Text('Cancel'))
                                    ],
                                  ))
                            ],
                          )
                              : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _isCommenting = !_isCommenting;
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.add_comment,
                                    color: Colors.blueAccent,
                                    size: 40,
                                  )),
                              const SizedBox(
                                width: 10,
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(
                                        () {
                                      showComment = !showComment;
                                    },
                                  );
                                },
                                icon: const Icon(
                                  Icons.arrow_drop_down_circle,
                                  color: Colors.blueAccent,
                                  size: 40,
                                ),
                              ),
                            ],
                          ),
                        ),
                        showComment == false ? Container() :
                        Padding(
                          padding: EdgeInsets.all(16),
                          child: FutureBuilder<DocumentSnapshot>(
                            future: FirebaseFirestore.instance.collection(
                                'jobs').doc(widget.jobID).get(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else {
                                if (snapshot.data == null) {
                                  return const Center(
                                    child: Text("No comment for this job"),);
                                }
                              }
                              return ListView.separated(
                                shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return CommentWidget(
                                      commentId: snapshot
                                          .data!['jobComments'][index]['commentId'],
                                      commenterId: snapshot
                                          .data!['jobComments'][index]['userId'],
                                      commenterName: snapshot
                                          .data!['jobComments'][index]['name'],
                                      commentBody: snapshot
                                          .data!['jobComments'][index]['commentBody'],
                                      commenterImageUrl: snapshot
                                          .data!['jobComments'][index]['userImageUrl'],);
                                  },
                                  physics: NeverScrollableScrollPhysics(),
                                  separatorBuilder: (context,index){
                                    return Divider(
                                      thickness: 1,
                                      color: Colors.grey,
                                    );
                                  },
                                  itemCount: snapshot.data!['jobComments'].length
                              );
                            },

                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
