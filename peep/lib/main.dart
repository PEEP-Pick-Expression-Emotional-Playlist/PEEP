import 'package:flutter/material.dart';
import 'package:peep/login/login_page.dart';
import 'package:firebase_core/firebase_core.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized(); //바인딩
  await Firebase.initializeApp();

  runApp(MyApp());
}

//0529 수정
class MyApp extends StatelessWidget {
  static final String title = 'Google SignIn';

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: title,
        theme: ThemeData(primarySwatch: Colors.deepOrange),
        home: BasePage(),
      );
}
