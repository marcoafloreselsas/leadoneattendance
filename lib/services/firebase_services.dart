import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseServices{
FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  Future<User?> signInWithGoogle() async{
    //VIDEO HINU
    final _auth = FirebaseAuth.instance;
    final dbRef = FirebaseDatabase.instance.ref().child("users");
    try {
      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        //VIDEO HINDU
        final FirebaseUser user = await _auth.currentUser(credential);
        userID = googleAuth.idToken;

        UserCredential userCredential = await firebaseAuth.signInWithCredential(credential);

        await FirebaseDatabase.instance
        .ref()
        .child("users")
        .child(userID)
        .once()
        .then(DataSnapshot snapshot){
          setState((){
            if(snapshot.value['role']=='admin'){
              Navigator.push(context, MaterialPageRoute(builder:(context) => MainScreenAdmin()));
            }
            else if(snapshot.value['role'] == 'user'){
              Navigator.push(context, MaterialPageRoute(builder:(context) => MainScreen()));
            }
          });
        };
        return userCredential.user;
      }
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }
  Future signOut()async{
    await GoogleSignIn().signOut();
    await firebaseAuth.signOut();

  }
}