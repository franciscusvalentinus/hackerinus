import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hackerinus/models/Tools.dart';
import 'package:hackerinus/repository/tools_repository.dart';
import 'package:hackerinus/utils/activity_util.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ToolServices{
  ToolServices._privateConstructor();

  static final ToolServices instance = ToolServices._privateConstructor();

  ToolsRepository toolsRepository = ToolsRepository.instance;

  Future<String> addTools(Tools tools,PickedFile pickedFile) async {
    Reference ref = FirebaseStorage.instance
        .ref()
        .child("images")
        .child(ActivityUtils.dateNow() + ".jpg");
    UploadTask uploadTask = ref.putFile(File(pickedFile.path));
    await uploadTask.whenComplete(() => ref.getDownloadURL().then(
          (value) => tools.imageUrl = value,
    ));
    toolsRepository.save(tools);
    return "Success";
  }

  Future<String> updatetools(Tools tools,PickedFile pickedFile) async{
    if(pickedFile != null){
      Reference ref = FirebaseStorage.instance
          .ref()
          .child("images")
          .child(ActivityUtils.dateNow() + ".jpg");
      UploadTask uploadTask = ref.putFile(File(pickedFile.path));
      await uploadTask.whenComplete(() => ref.getDownloadURL().then(
            (value) => tools.imageUrl = value,
      ));
    }
    toolsRepository.update(tools);
    return "Success";
  }

  Future<List<DocumentSnapshot>> getToolsFirstPage(){
    return toolsRepository.getToolsFirstPage();
  }




}