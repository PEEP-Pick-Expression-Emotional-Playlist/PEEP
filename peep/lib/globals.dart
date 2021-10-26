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
  static const BLUE      = "BLUE";
  static const ANGRY    = "ANGRY";
  static const CALM     = "CALM";
  static const FEAR     = "FEAR";
  static const DEFAULT  = "DEFAULT";

  static const _normalColorMap = {
    HAPPY:    const Color(0xFFd5b15c),
    BLUE:      const Color(0xFF7fbad0),
    ANGRY:    const Color(0xFFd77881),
    CALM:     const Color(0xFF669f82),
    FEAR:     const Color(0xFF8481ac),
    DEFAULT:  Colors.grey,
  };

  static const _lightColorMap = {
    HAPPY:    const Color(0xFFe8c075),
    BLUE:      const Color(0xFFa5c3d7),
    ANGRY:    const Color(0xFFd77d92),
    CALM:     const Color(0xFF57a481),
    FEAR:     const Color(0xFF8776a4),
    DEFAULT:  Colors.white,
  };

  static const _darkColorMap = {
    HAPPY:    const Color(0xFFd57a47),
    BLUE:      const Color(0xFF446199),
    ANGRY:    const Color(0xFFcc4e60),
    CALM:     const Color(0xFF426641),
    FEAR:     const Color(0xFF564986),
    DEFAULT:  Colors.black,
  };

  static const _processColorMap = {
    HAPPY:    const Color(0xFFE8C147),
    BLUE:      const Color(0xFF469DE2),
    ANGRY:    const Color(0xFFCC6065),
    CALM:     const Color(0xFF448265),
    FEAR:     const Color(0xFF61558E),
    DEFAULT:  Colors.black,
  };

  static const _barColorMap = {
    HAPPY:    const Color(0xFFF6E7B7),
    BLUE:      const Color(0xFFB7DAF4),
    ANGRY:    const Color(0xFFEBC2C4),
    CALM:     const Color(0xFFB6CEC3),
    FEAR:     const Color(0xFFC2BDD4),
    DEFAULT:  Colors.grey,
  };


  const EmotionColor._();

  static getNormalColorFor(String emotion) => _normalColorMap[emotion.toUpperCase()] ?? _normalColorMap[DEFAULT];
  static getLightColorFor(String emotion) => _lightColorMap[emotion.toUpperCase()] ?? _lightColorMap[DEFAULT];
  static getDarkColorFor(String emotion) => _darkColorMap[emotion.toUpperCase()] ?? _darkColorMap[DEFAULT];
  static getProcessColorFor(String emotion) => _processColorMap[emotion.toUpperCase()] ?? _processColorMap[DEFAULT];
  static getBarColorFor(String emotion) => _barColorMap[emotion.toUpperCase()] ?? _barColorMap[DEFAULT];
}