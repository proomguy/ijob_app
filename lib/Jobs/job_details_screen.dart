// ignore_for_file: unnecessary_null_comparison


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ijob_app/Jobs/jobs_screen.dart';
import 'package:ijob_app/Services/global_methods.dart';
import 'package:url_launcher/url_launcher_string.dart';

class JobDetailsScreen extends StatefulWidget {

  final String uploadedBy;
  final String jobID;

  const JobDetailsScreen({
    required this.uploadedBy,
    required this.jobID,
});

  @override
  State<JobDetailsScreen> createState() => _JobDetailsScreenState();
}

class _JobDetailsScreenState extends State<JobDetailsScreen> {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? authorName;
  String? userImageUrl;
  String? jobCategory;
  String? jobDescription;
  String? jobTitle;
  bool? jobRecruitment;
  Timestamp? postedDateTimeStamp;
  Timestamp? deadlineDateTimeStamp;
  String? postedDate;
  String? deadlineDate;
  String? locationCompany = '';
  String? emailCompany = '';
  int applicants = 0;
  bool isDeadlineAvailable = false;

  void getJobData() async{

    final DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(widget.uploadedBy).get();

    if(userDoc == null){
      return;
    }
    else{
      setState(() {
        authorName = userDoc.get('name');
        userImageUrl = userDoc.get('userImage');
      });
    }

    final DocumentSnapshot jobDatabase = await FirebaseFirestore.instance.collection('jobs').doc(widget.jobID).get();

    if(jobDatabase == null){
      return;
    }
    else{
      setState(() {
        jobTitle = jobDatabase.get('jobTitle');
        jobDescription = jobDatabase.get('jobDescription');
        jobRecruitment = jobDatabase.get('jobRecruitment');
        emailCompany = jobDatabase.get('email');
        locationCompany = jobDatabase.get('location');
        applicants = jobDatabase.get('applicants');
        postedDateTimeStamp = jobDatabase.get('createdAt');
        deadlineDateTimeStamp = jobDatabase.get('deadlineDateTimeStamp');
        deadlineDate = jobDatabase.get('deadlineDate');

        var postDate = postedDateTimeStamp!.toDate();

        postedDate = '${postDate.year}-${postDate.month}-${postDate.day}';

      });

      var date = deadlineDateTimeStamp!.toDate();
      isDeadlineAvailable = date.isAfter(DateTime.now());
    }

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getJobData();
  }

  Widget dividerWidget(){
    return const Column(
      children: [
        SizedBox(height: 10,),
        Divider(
          thickness: 1,
          color: Colors.grey,
        ),
        SizedBox(height: 10,),
      ],
    );
  }

  applyForJob() {
    final Uri params = Uri(
      scheme: 'mailto',
      path: emailCompany,
      query: 'subject=Applying for $jobTitle &body=Hello, I hereby applying for $jobTitle as advertised in the media. Please, Find my attached CV for your considerations',

    );
    final url = params.toString();
    launchUrlString(url);
    addNewApplicants();
  }

  void addNewApplicants() async {
    var docRef = FirebaseFirestore.instance.collection('jobs').doc(widget.jobID);
    docRef.update({
      'applicants': applicants + 1,
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.shade200, Colors.yellowAccent.shade100],
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
                colors: [Colors.yellowAccent.shade100, Colors.green.shade200],
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
            icon: const Icon(
              Icons.arrow_back_ios_outlined,
              color: Colors.black,
              size: 40,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Card(
                  color: Colors.black54,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: Text(
                            jobTitle == null ? '' : jobTitle!,
                            maxLines: 3,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 30
                            ),
                          ),
                        ),
                        const SizedBox(height: 20,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 3,
                                  color: Colors.grey
                                ),
                                shape: BoxShape.rectangle,
                                image: DecorationImage(
                                  image: NetworkImage(
                                    userImageUrl == null ? 'https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_1280.png' : userImageUrl!,
                                  ),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    authorName == null ? '' : authorName!,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.white
                                    ),
                                  ),
                                  const SizedBox(height: 5,),
                                  Text(
                                    locationCompany!,
                                    style: const TextStyle(
                                      color: Colors.grey
                                    ),
                                  ),
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
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(width: 6,),
                            const Text(
                              'Applicants',
                              style: TextStyle(
                                color: Colors.grey
                              ),
                            ),
                            const SizedBox(width: 10,),
                            const Icon(
                              Icons.how_to_reg_sharp,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                        FirebaseAuth.instance.currentUser!.uid != widget.uploadedBy ? Container() : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            dividerWidget(),
                            const Text(
                              'Recruitment',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            const SizedBox(height: 5,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextButton(
                                    onPressed: (){
                                      User? user = _auth.currentUser;
                                      final _uid = user!.uid;
                                      if(_uid == widget.uploadedBy){
                                        try{
                                          FirebaseFirestore.instance.collection('jobs').doc(widget.jobID).update({'jobRecruitment': true});
                                        }
                                        catch(error){
                                          GlobalMethod.showErrorDialog(
                                              error: 'Action can not be performed',
                                              ctx: context
                                          );
                                        }
                                      }
                                      else{
                                        GlobalMethod.showErrorDialog(
                                            error: 'You can not perform this task',
                                            ctx: context,
                                        );
                                      }
                                      getJobData();
                                    },
                                    child: const Text(
                                      'ON',
                                      style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.normal
                                      ),
                                    ),
                                ),
                                Opacity(
                                    opacity: jobRecruitment == true ? 1 : 0,
                                  child: const Icon(
                                    Icons.check_box,
                                    color: Colors.lightGreenAccent,
                                  ),
                                ),
                                const SizedBox(width: 40,),
                                TextButton(
                                  onPressed: (){
                                    User? user = _auth.currentUser;
                                    final _uid = user!.uid;
                                    if(_uid == widget.uploadedBy){
                                      try{
                                        FirebaseFirestore.instance.collection('jobs').doc(widget.jobID).update({'jobRecruitment': false});
                                      }
                                      catch(error){
                                        GlobalMethod.showErrorDialog(
                                            error: 'Action can not be performed',
                                            ctx: context
                                        );
                                      }
                                    }
                                    else{
                                      GlobalMethod.showErrorDialog(
                                        error: 'You can not perform this task',
                                        ctx: context,
                                      );
                                    }
                                    getJobData();
                                  },
                                  child: const Text(
                                    'OFF',
                                    style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.normal
                                    ),
                                  ),
                                ),
                                Opacity(
                                  opacity: jobRecruitment == false ? 1 : 0,
                                  child: const Icon(
                                    Icons.check_box,
                                    color: Colors.redAccent,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        dividerWidget(),
                        const Text(
                          'Job Description',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 10,),
                        Text(
                          jobDescription == null ? '' : jobDescription!,
                          textAlign: TextAlign.justify,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                        dividerWidget(),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Card(
                  color: Colors.black54,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10,),
                        Center(
                          child: Text(
                            isDeadlineAvailable ? 'Actively Recruiting, Send in CV/Resume' : 'Deadline Passed long ago',
                            style: TextStyle(
                              color: isDeadlineAvailable ? Colors.green : Colors.red,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.normal,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6,),
                        Center(
                          child: MaterialButton(
                            onPressed: (){
                              applyForJob();
                            },
                            color: Colors.blueAccent,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(13),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 14),
                              child: Text(
                                'Apply for this Job',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14
                                ),
                              ),
                            ),
                          ),
                        ),
                        dividerWidget(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Uploaded on: ',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            Text(
                              postedDate == null ? '' : postedDate!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Deadline Date :',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            Text(
                              deadlineDate == null ? '' : deadlineDate!,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14
                              ),
                            ),
                          ],
                        ),
                        dividerWidget(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
