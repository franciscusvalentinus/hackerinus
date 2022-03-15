import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hackerinus/models/Course.dart';

class CourseRepository {
  CourseRepository._privateConstructor();

  static final CourseRepository instance = CourseRepository._privateConstructor();

  CollectionReference collectionReference = FirebaseFirestore.instance.collection('courses');

  void save(Course t){
    Map<String,dynamic> wrapData = {
      "title" : t.title,
      "imageUrl" : t.imageUrl,
      "description" : t.description,
      "createdBy" : t.createdBy,
      "createdDate" : t.createdDate,
      "updatedDate" : t.updatedDate
    };
    collectionReference.add(wrapData)
        .then((value) => print("Tools added"))
        .catchError((error)=>print("Failed to add tool: $error"));
  }

  void update(Course t){
    Map<String,dynamic> wrapData = {
      "title" : t.title,
      "imageUrl" : t.imageUrl,
      "description" : t.description,
      "createdBy" : t.createdBy,
      "createdDate" : t.createdDate,
      "updatedDate" : t.updatedDate
    };
    collectionReference.doc(t.id).update(wrapData)
        .then((value) => print("Tools updated"))
        .catchError((error)=>print("Failed to update tool: $error"));
  }

  Future<List<DocumentSnapshot>> getToolsFirstPage() async {
    QuerySnapshot querySnapshot = await collectionReference.orderBy("createdAt")
        .limit(10)
        .get();
    final allData = querySnapshot.docs;
    return allData;
  }

  Future<List<DocumentSnapshot>> getToolsNextPage(List<DocumentSnapshot> documentList) async {
    QuerySnapshot querySnapshot = await collectionReference.orderBy("createdAt")
        .startAfterDocument(documentList[documentList.length - 1])
        .limit(10)
        .get();
    final allData = querySnapshot.docs;
    return allData;
  }

  Future<void> deleteById(String docId) async{
    await collectionReference
        .doc(docId)
        .delete()
        .then((value) => print("User Deleted"))
        .catchError((error) => print("Failed to delete Tools: $error"));
  }
}
