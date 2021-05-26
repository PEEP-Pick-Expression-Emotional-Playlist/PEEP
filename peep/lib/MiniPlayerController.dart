import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'PlayerPage/MusicPlayerPage.dart';
import 'PlayerPage/PlayerController.dart';

class MiniPlayerController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        LinearProgressIndicator(
            value: 0.5,
            backgroundColor: Colors.black26,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.black)),
        ColoredBox(
            color: Colors.black12,
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 6,
                  child: InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    child: Container(
                      padding: EdgeInsets.all(16.0),
                      child: Text('Beautiful Mistakes'),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.bottomToTop,
                              child: MusicPlayerPage()));
                    },
                  ),
                ),
                Expanded(
                    flex: 4,
                    child: Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            PlayerController(
                              previousSize: 24.0,
                              playSize: 36.0,
                              nextSize: 24.0,
                            ),
                            IconButton(
                              padding: EdgeInsets.zero,
                              constraints: BoxConstraints(),
                              icon: Icon(Icons.list_rounded),
                              iconSize: 24.0,
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    new SnackBar(
                                        content:
                                        Text('onPressed Playlist Button')));
                              },
                            )
                          ],
                        ))),
              ],
            ))
      ],
    );
  }
}