import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
//login logic(not page)
class GoogleSignInProvider extends ChangeNotifier{
  final googleSignIn = GoogleSignIn();
  bool _isSigningIn = false;//false. loading 애니메이션 필드

  GoogleSignInProvider(){//initailize _isSigningin
    _isSigningIn = false;
  }

  bool get isSigningIn => _isSigningIn;//getter

  set isSigningIn(bool isSigningIn){//setter
    _isSigningIn = isSigningIn;
    notifyListeners();
  }

  Future login() async{//implement login method
    isSigningIn = true;//loading indicator가 보이게
    final user = await googleSignIn.signIn();//user information를 줌
    if(user == null){
      isSigningIn = false;//user가 null이면, loading indicator 숨기기
      return;
    }else{//if user logged in
      final googleAuth = await user.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);//firebase연결
    
      isSigningIn = false;//loading indicator 숨기기

    }
  }

  void logout() async{//logout method
    await googleSignIn.disconnect();
    FirebaseAuth.instance.signOut();
  }

}