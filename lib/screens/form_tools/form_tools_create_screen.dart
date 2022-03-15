import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hackerinus/models/Tools.dart';
import 'package:hackerinus/screens/placeholder_widget.dart';
import 'package:hackerinus/services/tools_services.dart';
import 'package:hackerinus/utils/activity_util.dart';
import 'package:image_picker/image_picker.dart';

class FormToolScreen extends StatefulWidget {
  @override
  _FormToolScreenState createState() => _FormToolScreenState();
}

class _FormToolScreenState extends State<FormToolScreen> {

  final _formKey = GlobalKey<FormState>();
  final TextEditingController ctrlDesc = TextEditingController();
  final TextEditingController ctrlTitle = TextEditingController();

  ToolServices _toolServices = ToolServices.instance;

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
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.black,
        title: Text("Add Tools"),
      ),
      body: Container(
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
                  child: Text("Tools Name",style: TextStyle(color: Colors.white,fontSize: 18.0),)
              ),
            ),
            Container(
              margin: EdgeInsets.all(10.0),
              child: TextFormField(
                controller: ctrlTitle,
                style: TextStyle(color: Colors.white),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please fil the field!";
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10.0),
                  hintText: "Tools Name",
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
                minLines: 1,//Normal textInputField will be displayed
                maxLines: 7,// w
                controller: ctrlDesc,
                style: TextStyle(color: Colors.white),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please fil the field!";
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(10.0),
                  hintText: "Description",
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
            ElevatedButton.icon(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  //melanjutkan ke tahap berikutnya
                  setState(() {
                    isLoading = true;
                  });
                  Tools item = Tools(
                    "",
                    ctrlTitle.text,
                    "",
                    ctrlDesc.text,
                    FirebaseAuth.instance.currentUser!.uid,
                    ActivityUtils.dateNow(),
                    ActivityUtils.dateNow(),
                  );
                  await _toolServices.addTools(
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
              label: Text("Save Product"),
              style: ElevatedButton.styleFrom(
                  primary: Colors.deepOrange[400], elevation: 4),
            ),
          ],),
        ),
      ),
    );
  }
}
