import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hackerinus/models/Course.dart';
import 'package:hackerinus/repository/course_repository.dart';
import 'package:hackerinus/utils/activity_util.dart';
import 'package:image_picker/image_picker.dart';

class CourseService{
  CourseService._privateConstructor();

  static final CourseService instance = CourseService._privateConstructor();

  CourseRepository courseRepository = CourseRepository.instance;

  Future<String> addTools(Course t,PickedFile pickedFile) async {
    Reference ref = FirebaseStorage.instance
        .ref()
        .child("images")
        .child(ActivityUtils.dateNow() + ".jpg");
    UploadTask uploadTask = ref.putFile(File(pickedFile.path));
    await uploadTask.whenComplete(() => ref.getDownloadURL().then(
          (value) => t.imageUrl = value,
    ));
    courseRepository.save(t);
    return "Success";
  }

  Future<String> updatetools(Course t,PickedFile pickedFile) async{
    if(pickedFile != null){
      Reference ref = FirebaseStorage.instance
          .ref()
          .child("images")
          .child(ActivityUtils.dateNow() + ".jpg");
      UploadTask uploadTask = ref.putFile(File(pickedFile.path));
      await uploadTask.whenComplete(() => ref.getDownloadURL().then(
            (value) => t.imageUrl = value,
      ));
    }
    courseRepository.update(t);
    return "Success";
  }

  Future<List<DocumentSnapshot>> getToolsFirstPage(){
    return courseRepository.getToolsFirstPage();
  }
}