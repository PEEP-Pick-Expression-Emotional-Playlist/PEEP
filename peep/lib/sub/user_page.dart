import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:peep/login/google_sign_in.dart';
import 'package:provider/provider.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
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
    return Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.fromLTRB(15.0, 35.0, 15.0, 0.0),
          child: SingleChildScrollView(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: CircleAvatar(
                  //user 이미지
                  radius: 50,
                  backgroundImage: NetworkImage(photo),
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              Center(
                child: Text(
                  name, //user이름
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Center(
                child: Text(
                  '안녕하세요. 반갑습니다 :)',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 8.0,),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Color(0xfff6f7f9),
                    ),
                  //logout 버튼
                  onPressed: () {
                    final provider = Provider.of<GoogleSignInProvider>(context,
                        listen: false);
                    provider.logout(); //logout method 호출
                  },
                  child: Text('Logout'),
                ),
              ),
              SizedBox(
                height: 35.0,
              ),
              Text(
                'MY 플레이리스트',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              
              Container(
          // 수평적으로 대칭(symmetric)의 마진을 추가 -> 화면 위, 아래에 20픽세의 마진 삽입
          margin: EdgeInsets.symmetric(vertical: 20.0),
          // 컨테이너의 높이를 200으로 설정
          height: 40.0,
          // 리스트뷰 추가
          child: ListView(
            // 스크롤 방향 설정. 수평적으로 스크롤되도록 설정
            scrollDirection: Axis.horizontal,
            // 컨테이너들을 ListView의 자식들로 추가
            children: <Widget>[
              Container(
                
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xfff6f7f9),
                    ),
                    onPressed: () {
                      //버튼 클릭 시 사용자가 커스터마이징한 CALM 플레이리스트
                    },
                    child: Text(
                      'HAPPY',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
              ),
              Container(
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xfff6f7f9),
                    ),
                    onPressed: () {
                      //버튼 클릭 시 사용자가 커스터마이징한 CALM 플레이리스트
                    },
                    child: Text(
                      'BLUE',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
              ),
              Container(
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xfff6f7f9),
                    ),
                    onPressed: () {
                      //버튼 클릭 시 사용자가 커스터마이징한 CALM 플레이리스트
                    },
                    child: Text(
                      'ANGRY',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
              ),
              Container(
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xfff6f7f9),
                    ),
                    onPressed: () {
                      //버튼 클릭 시 사용자가 커스터마이징한 CALM 플레이리스트
                    },
                    child: Text(
                      'CALM',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
              ),
              Container(
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xfff6f7f9),
                    ),
                    onPressed: () {
                      //버튼 클릭 시 사용자가 커스터마이징한 CALM 플레이리스트
                    },
                    
                    child: Text(
                      'FEAR',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
              )
            ],
          ),
              ),
              SizedBox(
                height: 20.0,
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  '  좋아요 한 곡',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  '  최근에 들은 곡',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
              )
            ],
          )),
        ));
  }
}
