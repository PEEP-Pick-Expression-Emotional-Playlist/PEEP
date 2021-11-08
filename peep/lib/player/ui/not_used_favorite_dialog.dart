import 'package:flutter/material.dart';
import 'package:peep/login/user_manager.dart';

import '../../db_manager.dart';

enum Result { FAIL, ADD, REMOVE }

class _FavoriteDialogState extends State<FavoriteDialog> {
  IconData icon = Icons.wifi_protected_setup_rounded;
  Color color = Colors.white60;
  String message = "다시 시도해 주시기 바랍니다";

  final userFavoriteRef = DBManager.instance.ref
      .child("favorite")
      .child(UserManager.instance.user.uid);

  @override
  Widget build(BuildContext context) {

    return _dialog2();
  }
  //
  // _isFavoriteItem(){
  //   debugPrint("saved " + widget.songKey);
  //    userFavoriteRef
  //       .orderByChild(widget.songKey)
  //       .equalTo(true, key: widget.songKey)
  //       .get().then((value) {
  //      debugPrint("get " + value.value.toString());
  //      // Future.delayed(
  //      //     Duration(milliseconds: 1800), () => Navigator.of(context).pop(true));
  //      if (!value.exists) {
  //        userFavoriteRef.child(widget.songKey).set(true).then((value) {
  //          icon = Icons.favorite_rounded;
  //          color = widget.color;
  //          message = "이 음악을 좋아합니다";
  //
  //          // debugPrint("this key " + key);
  //          debugPrint("item " + widget.songKey + " add");
  //        });
  //      } else {
  //        userFavoriteRef.child(widget.songKey).remove().then((value) {
  //          icon = Icons.favorite_rounded;
  //          color = Colors.white60;
  //          message = "이 음악을 좋아하지 않습니다";
  //
  //          debugPrint("item removed");
  //        });
  //      }
  //    });
  // }

  Widget _dialog2() {
    debugPrint("saved " + widget.songKey);
    userFavoriteRef
        .orderByChild(widget.songKey)
        .equalTo(true, key: widget.songKey)
        .get().then((value) {
      debugPrint("get " + value.value.toString());
      // Future.delayed(
      //     Duration(milliseconds: 1800), () => Navigator.of(context).pop(true));
      if (!value.exists) {
        userFavoriteRef.child(widget.songKey).set(true).then((value) {
          icon = Icons.favorite_rounded;
          color = widget.color;
          message = "이 음악을 좋아합니다";

          // debugPrint("this key " + key);
          debugPrint("item " + widget.songKey + " add");
          return _dialog();
        });
      } else {
        userFavoriteRef.child(widget.songKey).remove().then((value) {
          icon = Icons.favorite_rounded;
          color = Colors.white60;
          message = "이 음악을 좋아하지 않습니다";

          debugPrint("item removed");
          return _dialog();
        });
      }
    });
    return CircularProgressIndicator();
  }

  Widget _dialog() {
    debugPrint("state" + message);
    return AlertDialog(
        backgroundColor: Colors.white70,
        // elevation: 0.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        content: Container(
            height: 200,
            width: 200,
            child: Column(children: [
              Icon(
                icon,
                color: color,
                size: 150.0,
              ),
              SizedBox(height: 10),
              Text(
                message,
                style: TextStyle(color: Colors.black87, fontSize: 20),
              )
            ])));
  }
}

class FavoriteDialog extends StatefulWidget {
  final String songKey;
  final Color color;

  FavoriteDialog({Key key, this.songKey, this.color}) : super(key: key);

  @override
  State<FavoriteDialog> createState() => _FavoriteDialogState();
}

// showDialog(
// barrierColor: Colors.white.withOpacity(0),
// context: context,
// builder: (context) {
// debugPrint("key " + _songMeta.key);
//
// return FavoriteDialog(
// songKey: _songMeta.key,
// color:
// EmotionColor.getNormalColorFor(playingEmotion));
//
// return CircularProgressIndicator();
// }),