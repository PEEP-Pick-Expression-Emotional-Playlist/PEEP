import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:peep/sub/home_page.dart';
import 'package:peep/sub/search_page.dart';
import 'package:peep/sub/user_page.dart';
import 'home/emotion_detection.dart';
import 'mini_player_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:io';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(HomePage());
// }

class AppFramePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PEEP',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        primaryColor: Colors.black,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: AppFrame(),
    );
  }
}

class AppFrame extends StatefulWidget {
  final FirebaseApp app;

  const AppFrame({Key key, this.app}) : super(key: key);

  @override
  _AppFrameState createState() => _AppFrameState();
}

class _AppFrameState extends State<AppFrame>
    with SingleTickerProviderStateMixin {
  int screenIndex = 0;
  List<Widget> screenList = [HomePage(), SearchPage(), UserPage()];
  final fb = FirebaseDatabase.instance;

  File _image;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    var name, photo, email, uid;
    if (user != null) {
      uid = user.uid;
      name = user.displayName;
      photo = user.photoURL;
      email = user.email;
    }
    final ref = fb.reference();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'PEEP',
          style: TextStyle(color: Colors.grey),
        ),
        iconTheme: IconThemeData(color: Colors.grey),
        backgroundColor: Colors.white,
        elevation: 0.0,
        actions: <Widget>[],
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(photo),
                backgroundColor: Colors.white,
              ),
              accountName: Text(
                name,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              accountEmail: Text(
                email,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 13,
                ),
              ),
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40.0),
                      bottomRight: Radius.circular(40.0))),
            ),
            ListTile(
              leading: Icon(
                Icons.settings,
                color: Colors.grey[850],
              ),
              title: Text('설정'),
              onTap: () {
                //클릭 시 설정 탭으로 이동
              },
              trailing: Icon(Icons.add),
            ),
            ListTile(
              leading: Icon(
                Icons.question_answer,
                color: Colors.grey[850],
              ),
              title: Text('도움말'),
              onTap: () {
                //클릭 시 도움말 탭으로 이동
              },
              trailing: Icon(Icons.add),
            ),
          ],
        ),
      ),
      body: screenList[screenIndex],
      bottomNavigationBar:
          Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        MiniPlayerController(), //하단 미니 음악 플레이어
        BottomNavigationBar(
          currentIndex: screenIndex,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: '검색'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'MY'),
          ],
          onTap: (value) {
            setState(() {
              screenIndex = value;
            });
          },
        )
      ]),
    );
  }

  Future<void> takePicture() async {
    final File imageFile =
        (await _picker.getImage(source: ImageSource.camera)) as File;
    if (imageFile == null) {
      print("no image");
      return;
    }
    final appDir = await getApplicationDocumentsDirectory();
    //await File(appDir.path+'/test.jpg').create(recursive: true);
    final File newImage = await imageFile.copy(appDir.path + '/test.jpg');
    setState(() {
      _image = newImage;
    });
  }
}
