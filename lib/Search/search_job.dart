import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ijob_app/Jobs/jobs_screen.dart';
import 'package:ijob_app/Widgets/job_widget.dart';


class SearchScreen extends StatefulWidget {


  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  final TextEditingController searchQueryTextEditingController = TextEditingController();
  String searchQuery = 'Search query';

  Widget _buildSearchField(){
    return TextField(
      controller: searchQueryTextEditingController,
      autocorrect: true,
      decoration: const InputDecoration(
        hintText: 'Search for Jobs here....',
        border: InputBorder.none,
        hintStyle: TextStyle(
          color: Colors.white,
          fontSize: 25
        ),
      ),
      style: const TextStyle(
        color: Colors.white,
        fontSize: 25,
      ),
      onChanged: (query) => updateSearchQuery(query),
    );
  }

  List<Widget> _buildActions(){
    return <Widget>[
      IconButton(
          onPressed: (){
            _clearSearchQuery();
          },
          icon: const Icon(Icons.clear,
            size: 25,
            color: Colors.red,
          ),
      ),
    ];
  }
  
  void _clearSearchQuery(){
    setState(() {
      searchQueryTextEditingController.clear();
      updateSearchQuery('');
    });
  }
  
  void updateSearchQuery(String newQuery){
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
          colors: [Colors.green.shade200, Colors.blueGrey.shade200],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          stops: const [0.2, 0.9],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blueGrey.shade200, Colors.green.shade200],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                stops: const [0.2, 0.9],
              ),
            ),
          ),
          leading: IconButton(
            onPressed: (){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const JobScreen()));
            },
            icon: const Icon(Icons.arrow_back),
            iconSize: 25,
          ),
          title: _buildSearchField(),
          actions: _buildActions(),
        ),
        body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('jobs')
              .where('jobTitle', isGreaterThanOrEqualTo: searchQuery)
              .where('jobRecruitment', isEqualTo: true)
              .snapshots(),
          builder: (context, AsyncSnapshot snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            else if(snapshot.connectionState == ConnectionState.active){
              if(snapshot.data?.docs.isNotEmpty == true){//Check here
                return ListView.builder(
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (BuildContext context, int index){
                    return JobWidget(
                        jobTitle: snapshot.data?.docs[index]['jobTitle'],
                        jobDescription: snapshot.data?.docs[index]['jobDescription'],
                        jobId: snapshot.data?.docs[index]['jobId'],
                        upLoadedBy: snapshot.data?.docs[index]['upLoadedBy'],
                        userImage: snapshot.data?.docs[index]['userImage'],
                        name: snapshot.data?.docs[index]['name'],
                        jobRecruitment: snapshot.data?.docs[index]['jobRecruitment'],
                        email: snapshot.data?.docs[index]['email'],
                        location: snapshot.data?.docs[index]['location']
                    );
                  },
                );
              }
              else{
                return const Center(
                  child: Text(
                    'No similar jobs',
                    style: TextStyle(
                      fontSize: 30,
                      fontFamily: 'Signatra',
                      fontWeight: FontWeight.normal,
                      fontStyle: FontStyle.normal
                    ),
                  ),
                );
              }
            }
            return const Center(
              child: Text(
                'Something seriously went wrong',
                style: TextStyle(
                    fontSize: 30,
                    fontFamily: 'Signatra',
                    fontWeight: FontWeight.normal,
                    fontStyle: FontStyle.normal
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
