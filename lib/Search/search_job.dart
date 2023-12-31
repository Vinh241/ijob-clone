import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project/Jobs/jobs_screen.dart';
import 'package:project/Widgets/job_widget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchQueryController = TextEditingController();
  String searchQuery = 'Search query';

  Widget _buildSearchField() {
    return TextField(
      autofocus: true,
      controller: _searchQueryController,
      autocorrect: true,
      decoration: const InputDecoration(
        hintText: 'Search for jobs...',
        border: InputBorder.none,
        hintStyle: TextStyle(
            color: Colors.white
        ),
      ),
      style: TextStyle(color: Colors.white, fontSize: 16),
      onChanged: (query) => updateSearchQuery(query),
    );
  }

  List<Widget> _buildActions() {
    return <Widget>[
      IconButton(onPressed: () {
        _clearSearchQuery();
      }, icon: Icon(Icons.clear)),

    ];
  }

  void _clearSearchQuery() {
    setState(() {
      _searchQueryController.clear();
      updateSearchQuery("");
    });
  }

  void updateSearchQuery(String newQuery) {
    setState(() {
      searchQuery = newQuery;
      print(searchQuery);
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
            onPressed: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => JobScreen()));
            },
            icon: Icon(Icons.arrow_back),
          ),
          title: _buildSearchField(),
          actions: _buildActions(),
        ),
        body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('jobs')
              .where('jobTitle', isGreaterThanOrEqualTo: searchQuery)
              .where('recruitment', isEqualTo: true).snapshots(),
          builder: (context,AsyncSnapshot snapshot){
            if(snapshot.connectionState== ConnectionState.waiting){
              return const Center(
                child: CircularProgressIndicator(),
              );
            }else if(snapshot.connectionState == ConnectionState.active){
              if(snapshot.data?.docs.isNotEmpty == true){
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context,index){
                    return JobWidget(
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
                    );

                  },
                );
              }else{
                return Center(
                  child: Text("There is no job"),
                );
              }
            }
            return Center(
              child: Text("Something went wrong",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30),),
            );
          },
        ),
      ),
    );
  }
}
