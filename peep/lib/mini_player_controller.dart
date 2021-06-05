import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:peep/player/music_player_page.dart';
import 'package:peep/player/player_controller.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
            color: const Color(0xfff6f7f9),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 6,
                  child: InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    child: Container(
                      padding: EdgeInsets.only(left:16.0, top: 16.0,bottom: 16.0,right: 8.0),
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
                        margin: EdgeInsets.only(left:8.0, top: 16.0,bottom: 16.0,right: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            PlayerController(
                              prevIconName: 'player_mini_prev',
                              playIconName: 'player_mini_play',
                              nextIconName: 'player_mini_next',
                              previousSize: 24.0,
                              playSize: 36.0,
                              nextSize: 24.0,
                            ),
                            IconButton(
                              padding: EdgeInsets.zero,
                              constraints: BoxConstraints(),
                              icon: SvgPicture.asset('assets/icons/player_mini_list.svg'),
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