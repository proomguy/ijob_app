// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ijob_app/Services/global_methods.dart';

class JobWidget extends StatefulWidget {
  
  final String jobTitle;
  final String jobDescription;
  final String jobId;
  final String upLoadedBy;
  final String userImage;
  final String name;
  final bool jobRecruitment;
  final String email;
  final String location;
  
  const JobWidget ({
    required this.jobTitle,
    required this.jobDescription,
    required this.jobId,
    required this.upLoadedBy,
    required this.userImage,
    required this.name,
    required this.jobRecruitment,
    required this.email,
    required this.location,
});

  @override
  State<JobWidget> createState() => _JobWidgetState();
}

class _JobWidgetState extends State<JobWidget> {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  _deleteDialog(){
    User? user = _auth.currentUser;
    final _uid = user!.uid;

    showDialog(
        context: context,
        builder: (ctx){
          return AlertDialog(
            actions: [
              TextButton(
                  onPressed: () async {
                    try{
                      if(widget.upLoadedBy == _uid){
                        await FirebaseFirestore.instance.collection('jobs')
                            .doc(widget.jobId)
                            .delete();
                        await Fluttertoast.showToast(
                          msg: 'Job has been deleted successfully',
                          toastLength: Toast.LENGTH_LONG,
                          backgroundColor: Colors.orangeAccent,
                          fontSize: 18.0
                        );
                        Navigator.canPop(context) ? Navigator.pop(context) : null;
                      }
                      else{
                        GlobalMethod.showErrorDialog(
                            error: 'You can not perform this action',
                            ctx: ctx
                        );
                      }
                    }
                    catch(error){
                      GlobalMethod.showErrorDialog(error: 'This job Can not be deleted', ctx: ctx);
                    }
                    finally{

                    }
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.delete_forever,
                        color: Colors.red,
                        size: 30,
                      ),
                      Text(
                        'Delete Job?',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 30
                        ),
                      ),
                    ],
                  ),
              ),
            ],
          );
        }
    );

  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white54,
      elevation: 8,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: ListTile(
        onTap: (){
          
        },
        onLongPress: (){
          _deleteDialog();
        },
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        leading: Container(
          padding: const EdgeInsets.only(right: 12),
          decoration: const BoxDecoration(
            border: Border(
              right: BorderSide(width: 1),
            ),
          ),
          child: Image.network(widget.userImage),
        ),
        title: Text(
          widget.jobTitle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.amber,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              widget.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8,),
            Text(
              widget.jobDescription,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.normal,
                fontSize: 15,
              ),
            ),
          ],
        ),
        trailing: const Icon(
          Icons.keyboard_arrow_right,
          size: 30,
          color: Colors.black,
        ),
      ),
    );
  }
}
