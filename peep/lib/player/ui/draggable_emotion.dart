import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';

import '../../globals.dart';

class DraggableEmotion extends StatelessWidget {
  const DraggableEmotion({
    Key key,
    this.emotion,
    this.svgIcon,
  }) : super(key: key);

  final String emotion;
  final String svgIcon;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: LongPressDraggable(
          data: emotion,
          dragAnchorStrategy: pointerDragAnchorStrategy,
          feedback: _draggingItem(),
          child: Container(
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 25,
                  width: 25,
                  child: SvgPicture.asset(
                    svgIcon,
                  ),
                ),
              ],
            ),
            height: 64.0,
          ),
        ));
  }
  
  Widget _draggingItem(){
    return FractionalTranslation(
      translation: const Offset(-0.5, -0.5),
      child: Container(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 25,
              width: 25,
              child: SvgPicture.asset(
                svgIcon,
              ),
            ),
          ],
        ),
        height: 64.0,
        width: 64.0,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: (emotion == "happy" || emotion == "fear")
                ? EmotionColor.getLightColorFor(emotion).withOpacity(0.7)
                : EmotionColor.getDarkColorFor(emotion).withOpacity(0.5)),
      ),
    );
  }
}