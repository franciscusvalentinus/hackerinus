import 'package:hackerinus/models/Tools.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ToolsRepository{

  ToolsRepository._privateConstructor();

  static final ToolsRepository instance = ToolsRepository._privateConstructor();

  CollectionReference collectionReference = FirebaseFirestore.instance.collection('tools');

  void save(Tools tools){
    Map<String,dynamic> wrapData = {
      "title" : tools.title,
      "imageUrl" : tools.imageUrl,
      "description" : tools.description,
      "createdBy" : tools.createdBy,
      "createdDate" : tools.createdDate,
      "updatedDate" : tools.updatedDate
    };
    collectionReference.add(wrapData)
        .then((value) => print("Tools added"))
        .catchError((error)=>print("Failed to add tool: $error"));
  }

  void update(Tools tools){
    Map<String,dynamic> wrapData = {
      "title" : tools.title,
      "imageUrl" : tools.imageUrl,
      "description" : tools.description,
      "createdBy" : tools.createdBy,
      "createdDate" : tools.createdDate,
      "updatedDate" : tools.updatedDate
    };
    collectionReference.doc(tools.id).update(wrapData)
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
