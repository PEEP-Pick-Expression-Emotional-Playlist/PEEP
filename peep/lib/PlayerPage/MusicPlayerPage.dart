import 'package:flutter/material.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:peep/PlayerPage/MyWaveClipper.dart';
import 'AudioWave.dart';
import 'DropdownDemo.dart';
import 'PlayerController.dart';

class MusicPlayerPage extends StatefulWidget {
  @override
  _MusicPlayerPageState createState() => new _MusicPlayerPageState();
}

class _MusicPlayerPageState extends State<MusicPlayerPage>
    with SingleTickerProviderStateMixin {
  final List<String> _yearValues = [
    "2020",
    "2010",
    "2000",
    "1990",
  ];

  final List<String> _genreValues = [
    "발라드",
    "힙합",
    "댄스",
    "...",
  ];

  String _emotionValue = "...";

  Animation<double> animation;
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: Duration(seconds: 4), vsync: this);
    _controller.repeat();
    //we set animation duration, and repeat for infinity

    animation = Tween<double>(begin: -400, end: 0).animate(_controller);
    //we have set begin to -600 and end to 0, it will provide the value for
    //left or right position for Positioned() widget to creat movement from left to right
    animation.addListener(() {
      setState(() {}); //update UI on every animation value update
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose(); //destory anmiation to free memory on last
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 0.0),
                        child: ExpansionTileCard(
                          expandedColor: Colors.black12,
                          shadowColor: Colors.transparent,
                          elevation: 0.0,
                          title: Row(children: <Widget>[
                            Container(
                              transform: Matrix4.translationValues(-16.0, 0, 0),
                              child: IconButton(
                                  icon: Icon(Icons.arrow_back_rounded),
                                  onPressed: () {
                                    Navigator.pop(context, true);
                                  }),
                            ),
                            Padding(
                                padding: EdgeInsets.symmetric(vertical: 4.0),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.horizontal(
                                            left: Radius.circular(10.0),
                                          ),
                                          border: Border.all(
                                            color: Colors.black,
                                            width: 1,
                                          )),
                                      child: DropDownDemo(
                                          hint: "연도", items: _yearValues),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.horizontal(
                                            right: Radius.circular(10.0),
                                          ),
                                          border: Border.all(
                                            color: Colors.black,
                                            width: 1,
                                          )),
                                      child: DropDownDemo(
                                        hint: "장르",
                                        items: _genreValues,
                                      ),
                                    ),
                                  ],
                                ))
                          ]),
                          children: <Widget>[
                            Padding(
                                padding:
                                    EdgeInsets.fromLTRB(4.0, 4.0, 4.0, 24.0),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: emotionButton(
                                          "Happiness", Icons.ac_unit_rounded),
                                    ),
                                    Expanded(
                                      child: emotionButton(
                                          "2", Icons.audiotrack_rounded),
                                    ),
                                    Expanded(
                                      child:
                                          emotionButton("3", Icons.adb_rounded),
                                    ),
                                    Expanded(
                                      child: emotionButton(
                                          "4", Icons.assistant_photo_rounded),
                                    ),
                                    Expanded(
                                      child: emotionButton(
                                          "5", Icons.bubble_chart_rounded),
                                    ),
                                  ],
                                ))
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 8.0, bottom: 4.0),
                        child: Text(
                          "Beautiful Mistakes",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 20, foreground: Paint()..strokeWidth = 2
                              // fontWeight: FontWeight.bold
                              ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 4.0, bottom: 8.0),
                        child: Text(
                          "Maroon 5, Megan Thee Stallion",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ),
                      Expanded(
                          child: Container(
                        // color: Colors.yellow,
                        decoration: new BoxDecoration(
                            shape: BoxShape.circle, color: Colors.black12
                            //
                            // image: new DecorationImage(
                            //     fit: BoxFit.fill,
                            //     image: new NetworkImage(
                            //         "https://i.imgur.com/BoN9kdC.png")
                            // )
                            ),
                        child: Stack(
                          children: [
                            Positioned(
                                bottom: 0,
                                right: animation.value,
                                child: ClipPath(
                                  clipper: MyWaveClipper(),
                                  child: Opacity(
                                    opacity: 0.5,
                                    child: Container(
                                      color: Colors.black,
                                      width: 900,
                                      height: 200,
                                    ),
                                  ),
                                )),
                            Positioned(
                              //helps to position widget where ever we want
                              bottom: 0,
                              //position at the bottom
                              left: animation.value,
                              //value of left from animation controller
                              child: ClipPath(
                                clipper: MyWaveClipper(),
                                //applying our custom clipper
                                child: Opacity(
                                  opacity: 0.5,
                                  child: Container(
                                    color: Colors.black,
                                    width: 900,
                                    height: 200,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                      AudioWave(),
                      Row(
                        children: <Widget>[
                          Expanded(
                              child: Text(
                            "02:34",
                            textAlign: TextAlign.left,
                          )),
                          Expanded(
                            child: Text(
                              "5:55",
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                      Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 16.0, horizontal: 48.0),
                              child: PlayerController(
                                previousSize: 36.0,
                                playSize: 48.0,
                                nextSize: 36.0,
                              ))),
                    ]))));
  }

  Widget emotionButton(String emotion, IconData icon) {
    return GestureDetector(
      onTap: () => setState(() => _emotionValue = emotion),
      child: Container(
        height: 64.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _emotionValue == emotion ? Colors.grey : Colors.black12,
        ),
        child: Icon(icon),
      ),
    );
  }
}
