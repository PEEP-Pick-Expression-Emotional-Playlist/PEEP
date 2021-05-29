import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:peep/login/google_sign_in.dart';
import 'package:provider/provider.dart';
//sign up button
class GoogleSignupButtonWidget extends StatelessWidget{
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.all(4),
    child: OutlineButton.icon(
        label: Text(
          'sign in with google',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize:14),
        ),
        shape: StadiumBorder(),
        padding: EdgeInsets.symmetric(horizontal:12, vertical:8),
        highlightedBorderColor: Colors.black,
        borderSide: BorderSide(color: Colors.black),
        textColor: Colors.black,
        icon: FaIcon(FontAwesomeIcons.google, color: Colors.red),//google icon
        onPressed: () {
          final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
          provider.login();//google sign in으로 이동(login 로직)
        },
      ),
    );
}