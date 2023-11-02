import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project/LoginPage/Services/global_method.dart';
import 'package:project/LoginPage/Services/global_variables.dart';
import 'package:project/Persistent/persistent.dart';
import 'package:project/Widgets/bottom_nav_bar.dart';
import 'package:uuid/uuid.dart';

class UploadJobNow extends StatefulWidget {
  const UploadJobNow({super.key});

  @override
  State<UploadJobNow> createState() => _UploadJobNowState();
}

class _UploadJobNowState extends State<UploadJobNow> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _jobCategoryController =
      TextEditingController(text: 'Select Job Category');
  final TextEditingController _jobTitleController =
      TextEditingController(text: '');
  final TextEditingController _jobDescriptionController =
      TextEditingController(text: '');
  final TextEditingController _jobDeadlineController = TextEditingController(text: 'Job Deadline Date');
  DateTime? picked;
  bool isLoading = false;
  Timestamp? deadlineDateTimeStamp;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _jobDeadlineController.dispose();
    _jobCategoryController.dispose();
    _jobDescriptionController.dispose();
    _jobTitleController.dispose();

  }
  Widget _textTitles({required String label}) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _textFormFields(
      {required String valueKey,
      required TextEditingController controller,
      required bool enabled,
      required Function fct,
      required int maxLength}) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: InkWell(
        onTap: () {
          fct();
        },
        child: TextFormField(
          validator: (value) {
            if (value!.isEmpty) {
              return 'Value is missing';
            }
            return null;
          },
          controller: controller,
          enabled: enabled,
          key: ValueKey(valueKey),
          style: TextStyle(
            color: Colors.white,
          ),
          maxLines: valueKey == 'JobDescription' ? 2 : 1,
          maxLength: maxLength,
          keyboardType: TextInputType.text,
          decoration: const InputDecoration(
              filled: true,
              fillColor: Colors.black54,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              errorBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              )),
        ),
      ),
    );
  }

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
                        _jobCategoryController.text =
                            Persistent.jobCategoryList[index];
                      });
                      Navigator.of(context).pop();
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
              TextButton(onPressed: (){
                Navigator.of(context).canPop() ? Navigator.of(context).pop() : null;
              }, child: Text('Cancel',style: TextStyle(
                color: Colors.white,
                fontSize: 16
              ),))
            ],
          );
        });
  }
  void _pickDateDialog() async{
    picked = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now().subtract(
      Duration(days: 0)
    ), lastDate: DateTime(2100) );
    if(picked !=null){
      setState(() {
        _jobDeadlineController.text = '${picked!.day} -${picked!.month} - ${picked!.year} ';
        deadlineDateTimeStamp = Timestamp.fromMicrosecondsSinceEpoch(picked!.microsecondsSinceEpoch);

      });
    }
    FocusManager.instance.primaryFocus?.unfocus();
  }
  void _uploadTask() async {
    final jobId = const Uuid().v4();
    User? user = FirebaseAuth.instance.currentUser;
    final _uid = user!.uid;
    final isValid = _formKey.currentState!.validate();
    if(isValid){
      if(_jobDeadlineController == 'Job Deadline Date' || _jobCategoryController.text== 'Select Job Category'){
        GlobalMethod.showErrorDialog(error: 'Please pick everything', ctx: context);
        return;
      }
      setState(() {
        isLoading = true;
      });
      try{
       await FirebaseFirestore.instance.collection('jobs').doc(jobId).set({
         'id' : jobId,
         'uploadedBy': _uid,
         'email': user.email,
          'jobTitle': _jobTitleController.text,
         'jobDescription': _jobDescriptionController.text,
         'deadlineDate': _jobDeadlineController.text,
         'deadlineDataTimeStamp' : deadlineDateTimeStamp,
         'jobCategory': _jobCategoryController.text,
         'jobComments': [],
         'recruitment': true,
         'createdAt' : Timestamp.now(),
         'name': name,
          'userImage': userImage,
         'location': location,
         'applicant': 0,
       });
       await Fluttertoast.showToast(msg: 'The task has been uploaded',
       toastLength: Toast.LENGTH_LONG,
         backgroundColor: Colors.grey,
         fontSize: 18,
       );
       _jobTitleController.clear();
       _jobDescriptionController.clear();
       setState(() {
         _jobCategoryController.text = 'Select Job Category';
         _jobDeadlineController.text = 'Job Deadline Date';
       });
      }catch(e){
          setState(() {
            isLoading =false;
          });
          GlobalMethod.showErrorDialog(error: e.toString(), ctx: context);
      }
      finally{
        setState(() {
          isLoading =false;
        });
      }
    }else{
      print('Its not valid');
    }


  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.deepOrange.shade300, Colors.blueAccent],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              stops: [0.2, 0.9])),
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBarForApp(indexNum: 2),
        backgroundColor: Colors.transparent,
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Card(
              color: Colors.white10,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    const Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          'Please fill all fields',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Signatra'),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Divider(
                      thickness: 1,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _textTitles(label: 'Job category: '),
                              _textFormFields(
                                  valueKey: 'JobCategory',
                                  controller: _jobCategoryController,
                                  enabled: false,
                                  fct: () {
                                    _showTaskCategoryDialog(size: size);
                                  },
                                  maxLength: 100),
                              _textTitles(label: 'Job Title'),
                              _textFormFields(
                                  valueKey: 'JobTitle',
                                  controller: _jobTitleController,
                                  enabled: true,
                                  fct: () {},
                                  maxLength: 100),
                              _textTitles(label: 'Job Description'),
                              _textFormFields(
                                  valueKey: 'JobDescription',
                                  controller: _jobDescriptionController,
                                  enabled: true,
                                  fct: () {},
                                  maxLength: 100),
                              _textTitles(label: 'Job Deadline Date'),
                              _textFormFields(
                                  valueKey: 'Deadline',
                                  controller: _jobDeadlineController,
                                  enabled: false,
                                  fct: () {
                                    _pickDateDialog();
                                  },
                                  maxLength: 100)
                            ],
                          )),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 30),
                        child: isLoading
                            ? const CircularProgressIndicator()
                            : MaterialButton(
                                onPressed: () {
                                  _uploadTask();
                                },
                                color: Colors.black,
                                elevation: 8,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(13),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 14),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Post Now',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 25,
                                            fontFamily: 'Signatra'),
                                      ),
                                      SizedBox(
                                        width: 9,
                                      ),
                                      Icon(
                                        Icons.upload_file,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
