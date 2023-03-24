import 'package:flutter/material.dart';
import 'package:ijob_app/Persistent/persistent.dart';

import '../Widgets/bottom_nav_bar.dart';

class UploadJobNow extends StatefulWidget {
  const UploadJobNow({Key? key}) : super(key: key);

  @override
  State<UploadJobNow> createState() => _UploadJobNowState();
}

class _UploadJobNowState extends State<UploadJobNow> {

  final _formKey = GlobalKey<FormState>();
  final bool _isLoading = false;
  final TextEditingController _jobCategoryTextEditingController = TextEditingController(text: 'Select Job Category');
  final TextEditingController _jobTitleTextEditingController = TextEditingController();
  final TextEditingController _jobDescriptionTextEditingController = TextEditingController();
  final TextEditingController _deadlineDateTextEditingController = TextEditingController();

  Widget _textTitles({required String label}){
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold
        ),
      ),
    );
  }

  Widget _textFormFields({required String valueKey, required TextEditingController controller, required bool enabled, required Function fxt, required int maxLength}){
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: InkWell(
        onTap: (){
          fxt();
        },
        child: TextFormField(
          validator: (value){
            if(value!.isEmpty){
              return 'Value is missing';
            }
            return null;
          },
          controller: controller,
          enabled: enabled,
          key: ValueKey(valueKey),
          style: const TextStyle(
            color: Colors.white,
          ),
          maxLines: valueKey == 'JobDescription' ? 5 : 1,
          maxLength: maxLength,
          keyboardType: TextInputType.text,
          decoration: const InputDecoration(
            filled: true,
            fillColor: Colors.black54,
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black)
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.cyan)
            ),
            errorBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.red
              )
            ),
          ),
        ),
      ),
    );
  }

  _showJobCategoryDialog({required Size size}){
    showDialog(
        context: context,
        builder: (ctx){
          return AlertDialog(
            backgroundColor: Colors.cyanAccent,
            title: const Text(
              'Job Category',
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
                itemCount: Persistent.jobjCategoryList.length,
                itemBuilder: (ctx, index){
                  return InkWell(
                    onTap: (){
                      setState(() {
                        _jobCategoryTextEditingController.text = Persistent.jobjCategoryList[index];
                        Navigator.pop(context);
                      });
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
                            Persistent.jobjCategoryList[index],
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
                    'Cancel',
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 16
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
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.grey, Colors.blueGrey],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          stops: [0.2, 0.9],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        bottomNavigationBar: BottomNavigationBarForMyApp(indexNum: 2),
        appBar: AppBar(
          title: const Text(
              'Upload Jobs',
            style: TextStyle(
              color: Colors.white
            ),
          ),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blueGrey, Colors.grey],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                stops: [0.2, 0.9],
              ),
            ),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(7.0),
            child: Card(
              color: Colors.white10,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10,),
                    const Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Please fill ALL fields',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Signatra'
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10,),
                    const Divider(thickness: 1,),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _textTitles(label: "Job Category :"),
                            _textFormFields(
                                valueKey: 'JobCategory',
                                controller: _jobCategoryTextEditingController,
                                enabled: false,
                                fxt: (){
                                  _showJobCategoryDialog(size: size);
                                },
                                maxLength: 100,
                            ),
                            _textTitles(
                                label: 'Job Title :'
                            ),
                            _textFormFields(
                                valueKey: 'JobTitle',
                                controller: _jobTitleTextEditingController,
                                enabled: true,
                                fxt: (){

                                },
                                maxLength: 100
                            ),
                            _textTitles(
                                label: 'Job Description :'
                            ),
                            _textFormFields(
                                valueKey: 'JobDescription',
                                controller: _jobDescriptionTextEditingController,
                                enabled: true,
                                fxt: (){

                                },
                                maxLength: 300
                            ),
                            _textTitles(
                                label: 'Job Deadline Date :'
                            ),
                            _textFormFields(
                                valueKey: 'Deadline',
                                controller: _deadlineDateTextEditingController,
                                enabled: true,
                                fxt: (){

                                },
                                maxLength: 100
                            ),
                          ],
                        ),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 30),
                        child: _isLoading ? const CircularProgressIndicator() : MaterialButton(
                          onPressed: (){

                          },
                          color: Colors.black,
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
                                  'Post Job Now',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30,
                                    fontFamily: 'Signatra'
                                  ),
                                ),
                                SizedBox(width: 9,),
                                Icon(
                                  Icons.cloud_upload_outlined,
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
          ),
        ),
      ),
    );
  }
}
