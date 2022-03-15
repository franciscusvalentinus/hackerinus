import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hackerinus/models/UserStore.dart';
import 'package:hackerinus/repository/tools_repository.dart';
import 'package:hackerinus/repository/user_repository.dart';
import 'package:hackerinus/utils/activity_util.dart';
import 'package:hackerinus/utils/sharedprefs_util.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {

  AuthService._privateConstructor();

  static final AuthService instance = AuthService._privateConstructor();

  UserRepository _userRepository = UserRepository.instance;


  Future<bool> signIn(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      Stream<QuerySnapshot> userStore = await _userRepository.getByEmail(email);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool("IsLoggedIn", true);
      userStore.forEach((element) {
        prefs.setString("email", element.docs[0]['email']);
        prefs.setString("phone", element.docs[0]['phone']);
        prefs.setString("name", element.docs[0]['name']);
        prefs.setString("userJoinDate", element.docs[0]['createdDate']);
      });


      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
  Future<bool> register(String email, String password,String fullName, String phone) async {
    try {
      UserCredential abc =  await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      _userRepository.save(UserStore(abc.user!.uid,fullName,phone,email,password,ActivityUtils.dateNow(),ActivityUtils.dateNow()));
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
      return false;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> signOut() async {
    try{
      await FirebaseAuth.instance.signOut();
      await SharedPrefsUtil.setIsLogin(false);
      return true;
    } catch(e){
      print(e.toString());
      return false;
    }

  }
}
