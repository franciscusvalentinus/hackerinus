import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hackerinus/models/Course.dart';
import 'package:hackerinus/services/course_services.dart';
import 'package:hackerinus/utils/activity_util.dart';
import 'package:image_picker/image_picker.dart';

class FormCourseEditScreen extends StatefulWidget {
  @override
  _FormCourseEditScreenState createState() => _FormCourseEditScreenState();
}

class _FormCourseEditScreenState extends State<FormCourseEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final ctrlDesc = TextEditingController();
  final ctrlTitle = TextEditingController();

  CourseService _courseServices = CourseService.instance;

  bool isLoading = false;
  PickedFile? imageFile;
  final ImagePicker imagePicker = ImagePicker();


  Future chooseFile(String type) async {
    ImageSource imgSrc = ImageSource.gallery;
    if (type == "camera") {
      imgSrc = ImageSource.camera;
    } else if (type == "gallery") {
      imgSrc = ImageSource.gallery;
    }
    final selectedImage = await imagePicker.getImage(
      source: imgSrc,
      imageQuality: 50,
    );
    setState(() {
      imageFile = selectedImage!;
    });
  }

  void showFileDialog(BuildContext ctx) {
    showDialog(
        context: ctx,
        builder: (ctx) {
          return AlertDialog(
            title: Text("Confirmation"),
            content: Text("Pick image from:"),
            actions: [
              ElevatedButton.icon(
                onPressed: () {
                  chooseFile("camera");
                },
                icon: Icon(Icons.camera_alt),
                label: Text("Camera"),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  chooseFile("gallery");
                },
                icon: Icon(Icons.folder_outlined),
                label: Text("Gallery"),
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                ),
              ),
            ],
          );
        });
  }

  void clearForm() {
    ctrlTitle.clear();
    ctrlDesc.clear();
    setState(() {
      imageFile = null;
    });
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, ()
    {
      final Course course = ModalRoute
          .of(context)!
          .settings
          .arguments as Course;
      setState(() {
        ctrlTitle.text = course.title;
        ctrlDesc.text = course.description;
        ctrlTitle.text = course.title;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    final Course course = ModalRoute.of(context)!.settings.arguments as Course;
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                child: Text("Delete"),
                onTap: () async {
                  await _courseServices.courseRepository.deleteById(course.id);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ],
        elevation: 0.0,
        backgroundColor: Colors.black,
        title: Text("Course Detail"),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: media.height,
          color: Colors.black,
          padding: EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(children: [
              imageFile == null
                  ? InkWell(
                onTap: () {
                  showFileDialog(context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: course.imageUrl != "" ? Image.network(course.imageUrl,fit: BoxFit.contain) : Image.asset('assets/images/placeholder-img.png',fit: BoxFit.contain,
                    width: 175,),
                ),
              )
                  : InkWell(
                onTap: () {
                  showFileDialog(context);
                },
                child: Padding(
                  padding: EdgeInsets.all(0.0),
                  child: Image.file(
                    File(imageFile!.path),
                    fit: BoxFit.contain,
                    width: 175,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(7,15,0,1),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Course Name",style: TextStyle(color: Colors.white,fontSize: 18.0),)
                ),
              ),
              Container(
                margin: EdgeInsets.all(10.0),
                child: TextFormField(
                  style: TextStyle(color: Colors.white),
                  controller: ctrlTitle,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please fil the field!";
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    hintText: "Course Name",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                        color: Colors.deepOrangeAccent,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(7,15,0,1),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Description",style: TextStyle(color: Colors.white,fontSize: 18.0),)
                ),
              ),
              Container(
                margin: EdgeInsets.all(10.0),
                child: TextFormField(
                  style: TextStyle(color: Colors.white),
                  minLines: 1,//Normal textInputField will be displayed
                  maxLines: 7,// w
                  controller: ctrlDesc,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please fil the field!";
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                        color: Colors.deepOrangeAccent,
                      ),
                    ),
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.all(10.0),
                    hintText: "Description",
                  ),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    //melanjutkan ke tahap berikutnya
                    setState(() {
                      isLoading = true;
                    });
                    Course item = Course(
                      course.id,
                      ctrlTitle.text,
                      course.imageUrl,
                      ctrlDesc.text,
                      FirebaseAuth.instance.currentUser!.uid,
                      course.createdDate,
                      ActivityUtils.dateNow(),
                    );
                    await _courseServices.updatetools(
                        item, imageFile!)
                        .then((value) {
                      if (value == "Success") {
                        ActivityUtils.showToast(
                            "Add Tools successful!", Colors.green);
                        clearForm();
                        Navigator.pop(context);
                      } else {
                        setState(() {
                          isLoading=false;
                        });
                        ActivityUtils.showToast(
                            "Add Tools failed.", Colors.red);
                      }
                    });
                  } else {
                    //kosongkan aja
                    Fluttertoast.showToast(
                        msg: "Please check the fields!",
                        backgroundColor: Colors.red);
                  }
                },
                icon: Icon(Icons.save),
                label: Text("Update Course"),
                style: ElevatedButton.styleFrom(
                    primary: Colors.deepOrange[400], elevation: 4),
              ),
            ],),
          ),
        ),
      ),
    );
  }
}
