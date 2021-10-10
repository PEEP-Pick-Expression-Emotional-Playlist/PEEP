library peep.globals;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class CurrentEmotion extends InheritedWidget {
  const CurrentEmotion({
    Key key,
    this.emotion,
    Widget child,
  }) : super(key: key, child: child);

  final String emotion;

  static CurrentEmotion of(BuildContext context) {
    final CurrentEmotion result = context.dependOnInheritedWidgetOfExactType<CurrentEmotion>();
    assert(result != null, 'No CurrentEmotion found in context');
    return result;
  }

  @override
  bool updateShouldNotify(CurrentEmotion old) => emotion != old.emotion;
}

class EmotionColor {
  static const HAPPY    = "HAPPY";
  static const SAD      = "SAD";
  static const ANGRY    = "ANGRY";
  static const CALM     = "CALM";
  static const FEAR     = "FEAR";
  static const DEFAULT  = "DEFAULT";

  static const _normalColorMap = {
    HAPPY:    const Color(0xFFd5b15c),
    SAD:      const Color(0xFF7fbad0),
    ANGRY:    const Color(0xFFd77881),
    CALM:     const Color(0xFF669f82),
    FEAR:     const Color(0xFF8481ac),
    DEFAULT:  Colors.white,
  };

  static const _lightColorMap = {
    HAPPY:    const Color(0xFFe8c075),
    SAD:      const Color(0xFFa5c3d7),
    ANGRY:    const Color(0xFFd77d92),
    CALM:     const Color(0xFF57a481),
    FEAR:     const Color(0xFF8776a4),
    DEFAULT:  Colors.white,
  };

  static const _darkColorMap = {
    HAPPY:    const Color(0xFFd57a47),
    SAD:      const Color(0xFF446199),
    ANGRY:    const Color(0xFFcc4e60),
    CALM:     const Color(0xFF426641),
    FEAR:     const Color(0xFF564986),
    DEFAULT:  Colors.white,
  };

  const EmotionColor._();

  static getNormalColorFor(String emotion) => _normalColorMap[emotion.toUpperCase()] ?? _normalColorMap[DEFAULT];
  static getLightColorFor(String emotion) => _lightColorMap[emotion.toUpperCase()] ?? _lightColorMap[DEFAULT];
  static getDarkColorFor(String emotion) => _darkColorMap[emotion.toUpperCase()] ?? _darkColorMap[DEFAULT];
}