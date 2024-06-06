
// ignore: depend_on_referenced_packages

import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService{
  final FirebaseAuth _auth= FirebaseAuth.instance;
  // ignore: non_constant_identifier_names
  Future<User?> signUpWithEmailAndPassword(String email, String password) async{
    try{
      UserCredential credential= await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return credential.user;
    }catch(e){
      // ignore: avoid_print
      print("error iruku myiru");
    }
    return null;
  }

  // ignore: non_constant_identifier_names
  Future<User?> signInWithEmailAndPassword(String email, String password) async{
    try{
      UserCredential credential= await _auth.signInWithEmailAndPassword(email: email, password: password);
      return credential.user;
    }catch(e){
      // ignore: avoid_print
      print("error iruku myiru");
    }
    return null;
  }



}