import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:ijob_app/Services/global_methods.dart';
import 'package:ijob_app/Widgets/bottom_nav_bar.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../user_state.dart';

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
      GlobalMethod.showErrorDialog(
          error: error.toString(),
          ctx: context
      );
    }
    finally{
      _isLoading = false;
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

  Widget _contactBy({required Color color, required Function fxt, required IconData iconData}){
    return CircleAvatar(
      backgroundColor: color,
      radius: 25,
      child: CircleAvatar(
        radius: 23,
        backgroundColor: Colors.white,
        child: IconButton(
          icon: Icon(
            iconData,
            color: color,
          ),
          onPressed: (){
            fxt();
          },
        ),
      ),
    );
  }

  void _openWhatsAppChat() async{
    var url = 'https://wa.me/$phoneNumber?text=HelloWorld';
    launchUrlString(url);
  }

  void _mailTo() async{
    final Uri params = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=Greetings from $name &body=Hello, Kindly contact me on this email about your job comments',
    );
    final url = params.toString();
    launchUrlString(url);
  }

  void _callPhoneNumber() async{
    var url = 'tel://$phoneNumber';
    launchUrlString(url);
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
                          const SizedBox(height: 24,),
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
                            child: userInfo(
                                iconData: Icons.email,
                                content: email!
                            ),
                          ),
                          const SizedBox(height: 10,),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: userInfo(
                                iconData: Icons.phone,
                                content: phoneNumber!
                            ),
                          ),
                          const SizedBox(height: 15,),
                          const Divider(
                            thickness: 1,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 35,),
                          _isSameUser ? Container() : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _contactBy(
                                  color: Colors.green,
                                  fxt: (){
                                    _openWhatsAppChat();
                                  },
                                  iconData: FontAwesome.whatsapp
                              ),
                              _contactBy(
                                  color: Colors.redAccent,
                                  fxt: (){
                                    _mailTo();
                                  },
                                  iconData: Icons.mail_outlined
                              ),
                              _contactBy(
                                  color: Colors.lightGreen,
                                  fxt: (){
                                    _callPhoneNumber();
                                  },
                                  iconData: Icons.phone
                              ),
                            ],
                          ),
                          const SizedBox(height: 25,),
                          const Divider(
                            thickness: 1,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 25,),
                          !_isSameUser ? Container() : Center(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 30.0),
                              child: MaterialButton(
                                onPressed: (){
                                  _auth.signOut();
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const UserState()));
                                },
                                color: Colors.cyanAccent,
                                elevation: 8,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(13),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 14),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Log Out',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.normal,
                                          fontFamily: 'Signatra',
                                          fontSize: 28,
                                        ),
                                      ),
                                      SizedBox(width: 10,),
                                      Icon(
                                        Icons.logout_outlined,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: size.width * 0.26,
                        height: size.width * 0.26,
                        decoration: BoxDecoration(
                          color: Colors.cyanAccent,
                          shape: BoxShape.circle,
                          border: Border.all(
                            width: 8,
                            color: Theme.of(context).scaffoldBackgroundColor,
                          ),
                          image: DecorationImage(
                            image: NetworkImage(
                              imageUrl == null ? 'https://ionicframework.com/docs/img/demos/avatar.svg' : imageUrl!
                            ),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ],
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
