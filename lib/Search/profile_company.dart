import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ijob_app/Widgets/bottom_nav_bar.dart';

class ProfileScreen extends StatefulWidget {

  final String userID;

  const ProfileScreen({required this.userID});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? name;
  String? email = '';
  String? phoneNumber = '';
  String? imageUrl = '';
  String? joinedAt = '';
  bool _isLoading = false;
  bool _isSameUser = false;

  void getUserData() async{
    try{
      _isLoading = true;
      final DocumentSnapshot userDoc  = await FirebaseFirestore.instance.collection('users').doc(widget.userID).get();
      if(userDoc == null){
        return;
      }
      else{
        setState(() {
          name = userDoc.get('name');
          email = userDoc.get('email');
          phoneNumber = userDoc.get('phoneNumber');
          imageUrl = userDoc.get('userImage');
          Timestamp joinedAtTimeStamp = userDoc.get('createdAt');
          var joinedDate = joinedAtTimeStamp.toDate();
          joinedAt = '${joinedDate.year} - ${joinedDate.month} - ${joinedDate.day}';
        });
        User? user = _auth.currentUser;
        final _uid = user!.uid;
        setState(() {
          _isSameUser = _uid == widget.userID;
        });
      }
    }
    catch(error){
      _isLoading = false;
    }
    finally{

    }
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Widget userInfo({required IconData iconData, required String content}){
    return Row(
      children: [
        Icon(
          iconData,
          color: Colors.white,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(
            content,
            style: const TextStyle(
              color: Colors.white54
            ),
          ),
        ),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.orangeAccent.shade200, Colors.cyanAccent.shade200],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          stops: const [0.2, 0.9],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        bottomNavigationBar: BottomNavigationBarForMyApp(indexNum: 3),
        body: Center(
          child: _isLoading ? const Center(
            child: CircularProgressIndicator(),
          ) : SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 0),
              child: Stack(
                children: [
                  Card(
                    color: Colors.white10,
                    margin: const EdgeInsets.all(30),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 100,
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              name == null ? 'No Name' : name!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24.0
                              ),
                            ),
                          ),
                          const SizedBox(height: 15,),
                          const Divider(
                            thickness: 1,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 30,),
                          const Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              'Account Information',
                              style: TextStyle(
                                  color: Colors.white54,
                                  fontSize: 22.0
                              ),
                            ),
                          ),
                          const SizedBox(height: 15,),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: userInfo(iconData: Icons.email, content: email!),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: userInfo(iconData: Icons.phone, content: phoneNumber!),
                          ),
                          const SizedBox(height: 30,),
                          const Divider(
                            thickness: 1,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
