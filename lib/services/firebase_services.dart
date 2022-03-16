import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseServices {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  Future<User?> signInWithGoogle()async{
    try {
      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if(googleUser != null){
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken
        );
        UserCredential userCredential = await firebaseAuth.signInWithCredential(credential);
        return userCredential.user;
      }

    } catch (e) {
      // print(e);
    }
    return null;
  }

 Future signOut()async{
    await GoogleSignIn().signOut();
    await firebaseAuth.signOut();
 }

}