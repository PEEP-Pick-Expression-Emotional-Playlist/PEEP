import 'package:flutter/material.dart';

class AudioWave extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: Duration(seconds: 4),
        builder: (context, value, child) {
          return Container(
            width: 500,
            height: 100,
            child: Stack(
              children: [
                ShaderMask(
                  shaderCallback: (rect) {
                    return LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        stops: [value, value],
                        colors: [Colors.black, Colors.grey.withAlpha(100)])
                        .createShader(rect);
                  },
                  child: Container(
                      width: 500,
                      height: 100,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: Image.asset(
                                  "assets/images/temp_wave.png")
                                  .image))),
                ),
              ],
            ),
          );
        });
  }
}