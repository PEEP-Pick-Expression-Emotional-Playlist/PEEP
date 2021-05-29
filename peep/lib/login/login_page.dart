import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:peep/login/google_sign_in.dart';
import 'package:peep/login/sign_up_widget.dart';
import 'package:peep/login/logged_in_widget.dart';
import 'package:provider/provider.dart';
import 'package:peep/app_frame.dart';
//base page
class BasePage extends StatelessWidget{
  @override
  Widget build(BuildContext context) => Scaffold(
        body: ChangeNotifierProvider(
          create: (context) => GoogleSignInProvider(),
          child: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),//user login 내역이 변했는지 감지(매시간 체크).return user
            builder: (context, snapshot){
              final provider = Provider.of<GoogleSignInProvider>(context);

              if(provider.isSigningIn){//provider가 signing in이면, loading indicator 보이기
                return bulidLoading();
              }
              else if(snapshot.hasData){//로그인했으면, logged in widget 출력
                return AppFramePage();//메인화면으로
              }
              else{
                return SignUpWidget();//login 화면 출력
              }
              
              },
            ),
          ),
        );

  Widget bulidLoading() => Center(child: CircularProgressIndicator());//loading indicator
}
