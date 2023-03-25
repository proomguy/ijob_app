import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ijob_app/Search/search_job.dart';
import 'package:ijob_app/Widgets/bottom_nav_bar.dart';

import '../Persistent/persistent.dart';

class JobScreen extends StatefulWidget {
  const JobScreen({Key? key}) : super(key: key);

  @override
  State<JobScreen> createState() => _JobScreenState();
}

class _JobScreenState extends State<JobScreen> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? jobCategoryFilter;

  _showJobCategoryDialog({required Size size}){
    showDialog(
        context: context,
        builder: (ctx){
          return AlertDialog(
            backgroundColor: Colors.cyanAccent,
            title: const Text(
              ' Filter Job Category',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 25,
                  color: Colors.black
              ),
            ),
            content: SizedBox(
              width: size.width * 0.9,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: Persistent.jobCategoryList.length,
                itemBuilder: (ctx, index){
                  return InkWell(
                    onTap: (){
                      setState(() {
                        jobCategoryFilter = Persistent.jobCategoryList[index];
                      });
                      Navigator.canPop(context) ? Navigator.pop(context) : null;
                      if (kDebugMode) {
                        print(
                        'jobCategoryList[index], ${Persistent.jobCategoryList[index]}'
                      );
                      }
                    },
                    child: Row(
                      children: [
                        const Icon(
                          Icons.arrow_right_alt_outlined,
                          color: Colors.amber,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            Persistent.jobCategoryList[index],
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: (){
                  Navigator.canPop(context) ? Navigator.pop(context) : null;
                },
                child: const Text(
                  'Close',
                  style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 16
                  ),
                ),
              ),
              TextButton(
                  onPressed: (){
                    setState(() {
                      jobCategoryFilter = null;
                    });
                    Navigator.canPop(context) ? Navigator.pop(context) : null;
                  },
                  child: const Text(
                    'Cancel Filter',
                    style: TextStyle(
                      color: Colors.white
                    ),
                  ),
              ),
            ],
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
        bottomNavigationBar: BottomNavigationBarForMyApp(indexNum: 0),
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
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(
              Icons.filter_list_rounded,
              color: Colors.black,
            ),
            onPressed: (){
              _showJobCategoryDialog(size: size);
            },
          ),
          actions: [
            IconButton(
                onPressed: (){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => SearchScreen()));
                },
                icon: const Icon(
                  Icons.search_outlined,
                  color: Colors.black,
                ),
            ),
          ],
        ),
      ),
    );
  }
}
