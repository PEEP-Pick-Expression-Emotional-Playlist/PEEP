import 'package:flutter/material.dart';
import 'package:peep/login/google_signup_button.dart';
//login page(but not real page)
class SignUpWidget extends StatelessWidget{
  @override
  Widget build(BuildContext context) => buildSignUp();

  Widget buildSignUp() => Column(
    children: [
      Spacer(),
      Align(
        alignment: Alignment.center,
        child : Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          width: 175,
          child: Text(
            '   peep logo',
            style: TextStyle(
              color: Colors.black,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      Spacer(),//스페이스바
      GoogleSignupButtonWidget(),//signup 버튼
      Spacer()
    ],
  );
}