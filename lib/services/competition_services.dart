import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hackerinus/models/Competition.dart';
import 'package:hackerinus/repository/competition_repository.dart';
import 'package:hackerinus/utils/activity_util.dart';
import 'package:image_picker/image_picker.dart';

class CompetitionService{
  CompetitionService._privateConstructor();

  static final CompetitionService instance = CompetitionService._privateConstructor();

  CompetitionRepository competitionRepository = CompetitionRepository.instance;

  Future<String> addTools(Competition t,PickedFile pickedFile) async {
    Reference ref = FirebaseStorage.instance
        .ref()
        .child("images")
        .child(ActivityUtils.dateNow() + ".jpg");
    UploadTask uploadTask = ref.putFile(File(pickedFile.path));
    await uploadTask.whenComplete(() => ref.getDownloadURL().then(
          (value) => t.imageUrl = value,
    ));
    competitionRepository.save(t);
    return "Success";
  }

  Future<String> updatetools(Competition t,PickedFile pickedFile) async{
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
    competitionRepository.update(t);
    return "Success";
  }

  Future<List<DocumentSnapshot>> getToolsFirstPage(){
    return competitionRepository.getToolsFirstPage();
  }
}