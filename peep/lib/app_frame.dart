import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:peep/sub/home_page.dart';
import 'package:peep/sub/search_page.dart';
import 'package:peep/sub/user_page.dart';
import 'mini_player_controller.dart';
import 'package:firebase_core/firebase_core.dart';

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
            BottomNavigationBarItem(icon: SvgPicture.asset('assets/icons/home.svg'), label: '홈'),
            BottomNavigationBarItem(icon: SvgPicture.asset('assets/icons/search.svg'), label: '검색'),
            BottomNavigationBarItem(icon: SvgPicture.asset('assets/icons/folder.svg'), label: 'MY'),
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
}
