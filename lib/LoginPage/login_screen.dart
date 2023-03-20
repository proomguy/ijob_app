// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ijob_app/ForgetPassword/forget_password_screen.dart';
import 'package:ijob_app/Services/global_methods.dart';
import 'package:ijob_app/SignUpPagee/signup_screen.dart';

import '../Services/global_variables.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin{

  late Animation<double> _animation;
  late AnimationController _animationController;

  final _loginFormKey = GlobalKey<FormState>();
  final FocusNode _passFocusNode = FocusNode();

  final TextEditingController _emailTextEditingController = TextEditingController(text: '');
  final TextEditingController _passwordTextEditingController = TextEditingController(text: '');
  bool _obscureText = true;
  bool _isLoading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    _animationController.dispose();
    _emailTextEditingController.dispose();
    _passwordTextEditingController.dispose();
    _passFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _animationController = AnimationController(vsync: this, duration: const Duration(seconds: 20));
    _animation = CurvedAnimation(parent: _animationController, curve: Curves.linear)
      ..addListener(() {
        setState(() {

        });
      })
      ..addStatusListener((animationStatus) {
        if(animationStatus == AnimationStatus.completed){
          _animationController.reset();
          _animationController.forward();
        }
      });
    _animationController.forward();
    super.initState();
  }

  void _submitFormLogin() async {

    final isValid = _loginFormKey.currentState!.validate();
    if(isValid){
      setState(() {
        _isLoading = true;

      });
      try{
        await _auth.signInWithEmailAndPassword(
            email: _emailTextEditingController.text.trim().toLowerCase(),
            password: _passwordTextEditingController.text.trim(),
        );
        Navigator.canPop(context) ? Navigator.pop(context) : null;
      }
      catch(error){

        setState(() {
          _isLoading = false;
        });

        GlobalMethod.showErrorDialog(error: error.toString(), ctx: context);
        print('Error Occurred $error');

      }
    }
    setState(() {
      _isLoading = false;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CachedNetworkImage(
            imageUrl: loginUrlImage,
            placeholder: (context, url) => Image.asset(
              'assets/images/wallpaper.jpg',
              fit: BoxFit.fill,
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            alignment: FractionalOffset(_animation.value, 0),
          ),
          Container(
            color: Colors.black54,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 80),
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 80, right: 80),
                    child: Image.asset(
                      'assets/images/login.png'
                    ),
                  ),
                  const SizedBox(height: 15,),
                  Form(
                    key: _loginFormKey,
                    child: Column(
                      children: [
                        //Email Field
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () => FocusScope.of(context).requestFocus(_passFocusNode),
                          keyboardType: TextInputType.emailAddress,
                          controller: _emailTextEditingController,
                          validator: (value){
                            if(value!.isEmpty || !value.contains('@')){
                              return 'Please enter a valid Email Address';
                            }
                            else{
                              return null;
                            }
                          },
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 30
                          ),
                          decoration: const InputDecoration(
                            hintText: 'Email',
                            hintStyle: TextStyle(
                              color: Colors.white,
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)
                            ),
                            errorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.red)
                            ),
                          ),
                        ),
                        const SizedBox(height: 5,),

                        //Password Field
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          focusNode: _passFocusNode,
                          keyboardType: TextInputType.visiblePassword,
                          controller: _passwordTextEditingController,
                          obscureText: !_obscureText, //Will change the password dynamically
                          validator: (value){
                            if(value!.isEmpty || value.length < 7){
                              return 'Please enter a valid password';
                            }
                            else{
                              return null;
                            }
                          },
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 30
                          ),
                          decoration: InputDecoration(
                            suffixIcon: GestureDetector(
                              onTap: (){
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                              child: Icon(
                                _obscureText ? Icons.visibility : Icons.visibility_off,
                                color: Colors.white,
                              ),
                            ),
                            hintText: 'Password',
                            hintStyle: const TextStyle(
                              color: Colors.white,
                            ),
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)
                            ),
                            errorBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.red)
                            ),
                          ),
                        ),
                        const SizedBox(height: 15,),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: TextButton(
                            onPressed: (){

                              Navigator.push(context, MaterialPageRoute(builder: (context) => ForgetPasswordScreen()));

                            },
                            child: const Text(
                              'Forget Password?',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10,),
                        MaterialButton(
                          onPressed: _submitFormLogin,
                          color: Colors.cyan,
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 14),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Log In',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 40,),
                        Center(
                          child: RichText(
                            text: TextSpan(
                              children: [
                                const TextSpan(
                                  text: 'Do not have an account?',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16
                                  ),
                                ),
                                const TextSpan(text: '  '),
                                TextSpan(
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpScreen())),
                                  text: 'Sign Up Now',
                                  style: const TextStyle(
                                    color: Colors.cyan,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
