import 'package:flutter/material.dart';
import 'package:peep/login/google_signup_button.dart';

//login page(but not real page)
class SignUpWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => buildSignUp();

  Widget buildSignUp() => Row(children: [
        Expanded(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 150,
              width: 150,
              child: Image.asset('assets/logo_final_e.png'),
            ),
            SizedBox(height: 50),
            GoogleSignupButtonWidget(),
          ],
        )),
      ]);
}
