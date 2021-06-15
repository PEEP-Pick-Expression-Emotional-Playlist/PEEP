import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:peep/login/google_sign_in.dart';
import 'package:provider/provider.dart';

class GoogleSignupLogo extends StatelessWidget{
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.all(4),
    child: Image.asset('assets/logo_final.png')
    );
}