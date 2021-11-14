import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:peep/db_manager.dart';
import 'package:peep/login/user_manager.dart';
import 'package:peep/player/audio_manager.dart';
import 'package:peep/sub/home_page.dart';
import 'package:peep/sub/search_screen.dart';
import 'package:peep/sub/user_page.dart';
import 'mini_player_controller.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(HomePage());
// }

class AppFramePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    UserManager.instance.user = FirebaseAuth.instance.currentUser;

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
  const AppFrame({Key key}) : super(key: key);

  @override
  _AppFrameState createState() => _AppFrameState();
}

class _AppFrameState extends State<AppFrame>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  int screenIndex = 0;
  List<Widget> screenList = [HomePage(), SearchScreen(), UserPage()];
  var ref = DBManager.instance.ref; //firebase
  var user = UserManager.instance.user; //user

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    AudioManager.instance.player.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // Release the player's resources when not in use. We use "stop" so that
      // if the app resumes later, it will still remember what position to
      // resume from.
      AudioManager.instance.player.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    var name, photo, email, uid;
    if (user != null) {
      uid = user.uid;
      name = user.displayName;
      photo = user.photoURL;
      email = user.email;
    }
    ref.child("user").child(uid).child("username").set(name);
    ref.child("user").child(uid).child("email").set(email);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset("assets/logo_final.png", height: 20, width: 100,),
         // SvgPicture.asset('assets/itd/ITD_logo_leftside.svg')
        // Text(
        //   'PEE',
        //   style: TextStyle(color: Colors.grey),
        // ),
        iconTheme: IconThemeData(color: Colors.grey),
        backgroundColor: Colors.white,
        elevation: 0.0,
        actions:[
          IconButton(icon: Icon(Icons.settings), onPressed: (){
            Scaffold.of(context).openEndDrawer();
          })
        ],
        //<Widget>[],
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
            BottomNavigationBarItem(
                icon: SvgPicture.asset('assets/icons/home.svg'), label: '홈'),
            BottomNavigationBarItem(
                icon: SvgPicture.asset('assets/icons/search.svg'), label: '검색'),
            BottomNavigationBarItem(
                icon: SvgPicture.asset('assets/icons/folder.svg'), label: 'MY'),
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
