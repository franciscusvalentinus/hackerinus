import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hackerinus/models/Competition.dart';
import 'package:hackerinus/services/competition_services.dart';
import 'package:hackerinus/utils/activity_util.dart';
import 'package:image_picker/image_picker.dart';

import '../placeholder_widget.dart';
class FormCompetitionScreen extends StatefulWidget {
  @override
  _FormCompetitionScreenState createState() => _FormCompetitionScreenState();
}

class _FormCompetitionScreenState extends State<FormCompetitionScreen> {
  final _formKey = GlobalKey<FormState>();
  final ctrlDesc = TextEditingController();
  final ctrlTitle = TextEditingController();

  CompetitionService _competitionServices = CompetitionService.instance;

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
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.black,
        title: Text("Add Competition"),
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
                  child: Image.asset('assets/images/placeholder-img.png',fit: BoxFit.contain,
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
                    child: Text("Competition Name",style: TextStyle(color: Colors.white,fontSize: 18.0),)
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
                    contentPadding: EdgeInsets.all(10.0),
                    hintText: "Competition Name",
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
                    Competition item = Competition(
                      "",
                      ctrlTitle.text,
                      "",
                      ctrlDesc.text,
                      FirebaseAuth.instance.currentUser!.uid,
                      ActivityUtils.dateNow(),
                      ActivityUtils.dateNow(),
                    );
                    await _competitionServices.addTools(
                        item, imageFile!)
                        .then((value) {
                      if (value == "Success") {
                        ActivityUtils.showToast(
                            "Add Competition successful!", Colors.green);
                        clearForm();
                        Navigator.pop(context);
                      } else {
                        setState(() {
                          isLoading=false;
                        });
                        ActivityUtils.showToast(
                            "Add Competition failed.", Colors.red);
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
                label: Text("Save Competition"),
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
