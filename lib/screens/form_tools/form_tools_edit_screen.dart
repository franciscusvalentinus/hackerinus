import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hackerinus/constant/RouteConstant.dart';
import 'package:hackerinus/models/Tools.dart';
import 'package:hackerinus/services/tools_services.dart';
import 'package:hackerinus/utils/activity_util.dart';
import 'package:image_picker/image_picker.dart';

class FormToolEditScreen extends StatefulWidget {


  @override
  _FormToolEditScreenState createState() => _FormToolEditScreenState();
}

class _FormToolEditScreenState extends State<FormToolEditScreen> {

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
  void initState() {
    Future.delayed(Duration.zero, ()
    {
      final Tools tools = ModalRoute
          .of(context)!
          .settings
          .arguments as Tools;
      setState(() {
        ctrlTitle.text = tools.title;
        ctrlDesc.text = tools.description;
        ctrlTitle.text = tools.title;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    final Tools tools = ModalRoute.of(context)!.settings.arguments as Tools;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.black,
        title: Text("Tool Detail"),
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                child: Text("Delete"),
                onTap: () async {
                  // showDialog(
                  //     context: context,
                  //     builder: (_)=> AlertDialog(
                  //         title: new Text("My Super title"),
                  //         content: new Text("Hello World"),
                  //   ),
                  //   barrierDismissible: false
                  // );
                  await _toolServices.toolsRepository.deleteById(tools.id);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          height:media.height,
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
                  child: tools.imageUrl != "" ? Image.network(tools.imageUrl,fit: BoxFit.contain) : Image.asset('assets/images/placeholder-img.png',fit: BoxFit.contain,
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
                  style: TextStyle(color: Colors.white),
                  controller: ctrlDesc,
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
                      tools.id,
                      ctrlTitle.text,
                      tools.imageUrl,
                      ctrlDesc.text,
                      FirebaseAuth.instance.currentUser!.uid,
                      tools.createdDate,
                      ActivityUtils.dateNow(),
                    );
                    await _toolServices.updatetools(
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
                label: Text("Update Tool"),
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
