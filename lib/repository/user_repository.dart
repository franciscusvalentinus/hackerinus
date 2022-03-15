import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hackerinus/models/UserStore.dart';

class UserRepository {
  UserRepository._privateConstructor();

  static final UserRepository instance = UserRepository._privateConstructor();

  CollectionReference collectionReference = FirebaseFirestore.instance.collection('users');

  void save(UserStore user){
    Map<String,dynamic> wrapData = {
      "uid":user.uid,
      "name":user.name,
      "phone":user.phone,
      "email":user.email,
      "password":user.password,
      "createdAt":user.createdAt,
      "updatedAt":user.updatedAt,
    };
    collectionReference.add(wrapData)
        .then((value) => print("User added"))
        .catchError((error)=>print("Failed to add user: $error"));
  }

  Future<Stream<QuerySnapshot<Object?>>> getByEmail(String email) async {
    // ignore: non_constant_identifier_names
     UserStore auserStore = UserStore("", "", "", "", "", "", "");
     return collectionReference.where('email',isEqualTo: email).snapshots();

  }
}