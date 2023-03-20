// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ijob_app/Services/global_variables.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> with TickerProviderStateMixin{

  late Animation<double> _animation;
  late AnimationController _animationController;

  final TextEditingController _fullNameTextEditingController = TextEditingController(text: '');
  final TextEditingController _emailTextEditingController = TextEditingController(text: '');
  final TextEditingController _passwordTextEditingController = TextEditingController(text: '');
  final TextEditingController _phoneNumberTextEditingController = TextEditingController(text: '');
  final TextEditingController _locationTextEditingController = TextEditingController(text: '');

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _phoneNumberFocusNode = FocusNode();
  final FocusNode _positionCPFocusNode = FocusNode();

  bool _obscureText = true;
  final bool _isLoading = false;

  final _signUpFormKey = GlobalKey<FormState>();

  File? imageFile;

  @override
  void dispose() {
    _animationController.dispose();
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

  void _showImageDialog(){
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            backgroundColor: Colors.amber.shade200,
            title: const Text(
                'Please choose an option...',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 30,
                  fontFamily: 'Signatra'
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: (){
                    //Create a method that will capture image from camera
                    _getFromCamera();
                  },
                  child: const Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.camera,
                          color: Colors.deepOrange,
                        ),
                      ),
                      Text(
                        'Use Phone Camera',
                        style: TextStyle(
                          color: Colors.lightBlue,
                          fontSize: 25
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10,),
                InkWell(
                  onTap: (){
                    //Create a method that will capture image from Gallery
                    _getFromGallery();
                  },
                  child: const Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.image,
                          color: Colors.deepOrange,
                        ),
                      ),
                      Text(
                        'From Gallery',
                        style: TextStyle(
                            color: Colors.lightBlue,
                          fontSize: 25
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
    );
  }

  void _getFromCamera() async {
    XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    _cropImage(pickedFile!.path);
    Navigator.pop(context);
  }

  void _getFromGallery() async {
    XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    _cropImage(pickedFile!.path);
    Navigator.pop(context);
  }

  void _cropImage(filepath) async{
    CroppedFile? croppedImage = await ImageCropper().cropImage(
        sourcePath: filepath, maxHeight: 1080, maxWidth: 1080
    );
    if(croppedImage != null){
      setState(() {
        imageFile = File(croppedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          CachedNetworkImage(
            imageUrl: signUpUrlImage,
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
                  Form(
                    key: _signUpFormKey,
                    child: Column(
                      children: [
                        //Image upload
                        GestureDetector(
                          onTap: (){
                            // We create showImageDialog
                            _showImageDialog();
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: size.width * 0.24,
                              height: size.width * 0.24,
                              decoration: BoxDecoration(
                                border: Border.all(width: 1, color: Colors.cyan,),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: imageFile == null 
                                    ? const Icon(Icons.camera_enhance_outlined, color: Colors.cyan, size: 30,)
                                    : Image.file(imageFile!, fit: BoxFit.fill,),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15,),
                        //Full name text field
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () => FocusScope.of(context).requestFocus(_emailFocusNode),
                          keyboardType: TextInputType.name,
                          controller: _fullNameTextEditingController,
                          validator: (value){
                            if(value!.isEmpty){
                              return 'Please enter a valid name';
                            }
                            else{
                              return null;
                            }
                          },
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 25
                          ),
                          decoration: const InputDecoration(
                            hintText: 'Full name / Company Name',
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
                        const SizedBox(height: 15,),
                        //Email Text field
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () => FocusScope.of(context).requestFocus(_passwordFocusNode),
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
                              fontSize: 25
                          ),
                          decoration: const InputDecoration(
                            hintText: 'Email address',
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
                        const SizedBox(height: 15,),
                        //Password Text field
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () => FocusScope.of(context).requestFocus(_phoneNumberFocusNode),
                          keyboardType: TextInputType.visiblePassword,
                          controller: _passwordTextEditingController,
                          obscureText: !_obscureText,
                          validator: (value){
                            if(value!.isEmpty || value.length < 7){
                              return 'Please enter a valid Password';
                            }
                            else{
                              return null;
                            }
                          },
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 25
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
                        //Phone number Text field
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () => FocusScope.of(context).requestFocus(_positionCPFocusNode),
                          keyboardType: TextInputType.phone,
                          controller: _phoneNumberTextEditingController,
                          validator: (value){
                            if(value!.isEmpty){
                              return 'Please enter a valid phone number';
                            }
                            else{
                              return null;
                            }
                          },
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 25
                          ),
                          decoration: const InputDecoration(
                            hintText: 'Phone Number',
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
                        const SizedBox(height: 15,),
                        //Location Text field
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () => FocusScope.of(context).requestFocus(_positionCPFocusNode),
                          keyboardType: TextInputType.text,
                          controller: _locationTextEditingController,
                          validator: (value){
                            if(value!.isEmpty){
                              return 'Please enter a valid location';
                            }
                            else{
                              return null;
                            }
                          },
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 25
                          ),
                          decoration: const InputDecoration(
                            hintText: 'Physical Address',
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
                        const SizedBox(height: 25,),
                        _isLoading
                        ? const Center(
                          child: SizedBox(
                            width: 70,
                            height: 70,
                            child: CircularProgressIndicator(

                            ),
                          ),
                        )
                            :
                            MaterialButton(
                              onPressed: (){

                                //I will create submit form on sign up

                              },
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
                                      'Sign Up',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    )
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
                                  text: 'Already have account?',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal,
                                    fontStyle: FontStyle.italic,
                                    fontSize: 16,
                                  ),
                                ),
                                const TextSpan(text: '  '),
                                TextSpan(
                                  recognizer: TapGestureRecognizer()..onTap = () => Navigator.canPop(context)
                                      ? Navigator.pop(context)
                                      : null,
                                  text: 'Log in',
                                  style: const TextStyle(
                                    color: Colors.cyan,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 16,
                                  ),
                                ),
                              ]
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
