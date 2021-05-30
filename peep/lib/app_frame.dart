import 'package:firebase_database/firebase_database.dart';
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

class _AppFrameState extends State<AppFrame> with SingleTickerProviderStateMixin {
  int screenIndex = 0;
  List<Widget> screenList = [HomePage(), SearchPage(), UserPage()];
  final fb = FirebaseDatabase.instance;

  File _image;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    final ref = fb.reference();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'PEEP',
          style: TextStyle(color: Colors.grey),
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.camera_alt),
              onPressed: () {
                print('Camera button is clicked');
                takePicture();
                Navigator.push(
                  //getImage(ImageSource.camera);
                  context,
                  MaterialPageRoute(builder: (context) => EmotionDetect())
                  );
                }
                )
                // ref.child("abc").set("yoyoyo"); //파이어베이스 데이터 보내기!!!
                //감정인식 카메라 버튼 누르면 카메라 화면으로 이동
        ],
      ),
      body: screenList[screenIndex],
      bottomNavigationBar:
          Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        MiniPlayerController(), //하단 미니 음악 플레이어
        BottomNavigationBar(
          currentIndex: screenIndex,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home, color: Colors.grey), label: '홈'),
            BottomNavigationBarItem(
                icon: Icon(Icons.search, color: Colors.grey), label: '검색'),
            BottomNavigationBarItem(
                icon: Icon(Icons.person, color: Colors.grey), label: 'MY'),
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
  Future<void> takePicture() async{
    final File imageFile = (await _picker.getImage(source: ImageSource.camera)) as File;
    if(imageFile == null){
      print("no image");
      return;
    }
    final appDir = await getApplicationDocumentsDirectory();
    //await File(appDir.path+'/test.jpg').create(recursive: true);
    final File newImage = await imageFile.copy(appDir.path+'/test.jpg');
    setState(() {
      _image = newImage;
    });

  }
}
