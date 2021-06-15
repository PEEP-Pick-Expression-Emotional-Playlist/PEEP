import 'package:flutter/material.dart';
import 'package:peep/login/google_signup_button.dart';
import 'package:peep/login/signup_logo.dart';
import 'package:flutter_svg/svg.dart';
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
          color: Colors.black,
          width: 100,
          child: SvgPicture.asset('assets/itd/ITD_logo_firstpage',
          )
          
        ),
      ),
      Container(
        height: 150,
        width: 150,
        
        child: Image.asset('assets/logo_final_e.png'),
      ),
      SizedBox(
        height: 50,
      ),
      GoogleSignupButtonWidget(),//signup 버튼
      Spacer()
      
    ],
  );
  
}