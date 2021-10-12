import 'package:flutter/cupertino.dart';

import 'my_wave_clipper.dart';

class AnimatedWave extends AnimatedWidget {
  final Color color;
  final double opacity;
  final double bottom;

  /// true: left to right
  /// false: right to left
  final bool isLeftToRight;

  const AnimatedWave({
    Key key,
    Animation<double> animation,
    this.bottom,
    this.opacity,
    this.color,
    this.isLeftToRight,
  }) : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
    double left, right;
    isLeftToRight ? right = animation.value : left = animation.value;
    return Positioned(
      bottom: bottom,
      left: left,
      right: right,
      child: ClipPath(
        clipper: MyWaveClipper(),
        child: Opacity(
          opacity: opacity,
          child: Container(
            color: color,
            width: 900,
            height: 200,
          ),
        ),
      ),
    );
  }
}