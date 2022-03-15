import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hackerinus/models/Competition.dart';

class CompetitionRepository {
  CompetitionRepository._privateConstructor();

  static final CompetitionRepository instance = CompetitionRepository._privateConstructor();

  CollectionReference collectionReference = FirebaseFirestore.instance.collection('competition');

  void save(Competition t){
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

  void update(Competition t){
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
