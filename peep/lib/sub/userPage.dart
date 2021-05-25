import 'package:flutter/material.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
          padding: EdgeInsets.fromLTRB(15.0, 35.0, 15.0, 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: CircleAvatar(
                  //사용자 프로필
                  //현재는 임의의 고정 이미지로 넣어둠
                  backgroundColor: Colors.grey,
                  backgroundImage: AssetImage('assets/dataex.png'),
                  radius: 50,
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              Center(
                child: Text(
                  'USERNAME',
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
              Row(
                children: <Widget>[
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.grey,
                    ),
                    onPressed: () {
                      //버튼 클릭 시 사용자가 커스터마이징한 HAPPY 플레이리스트
                    },
                    child: Text(
                      'HAPPY',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.grey,
                    ),
                    onPressed: () {
                      //버튼 클릭 시 사용자가 커스터마이징한 BLUE 플레이리스트
                    },
                    child: Text(
                      'BLUE',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.grey,
                    ),
                    onPressed: () {
                      //버튼 클릭 시 사용자가 커스터마이징한 SURPRISED 플레이리스트
                    },
                    child: Text(
                      'SURPRISED',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.grey,
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
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.grey,
                    ),
                    onPressed: () {
                      //버튼 클릭 시 사용자가 커스터마이징한 TIRED 플레이리스트
                    },
                    child: Text(
                      'TIRED',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
    );
  }
}
