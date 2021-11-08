import 'package:flutter/material.dart';

import 'dropdown_demo.dart';

class TwoStickyBorderDropdown extends StatelessWidget {
  final String leftHint;
  final String rightHint;
  final List<String> leftItem;
  final List<String> rightItem;
  final Color backgroundColor;

  const TwoStickyBorderDropdown(
      {Key key,
        this.leftHint,
        this.rightHint,
        this.leftItem,
        this.rightItem,
        this.backgroundColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Padding(
          padding: EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            children: [
              _halfDropdown(true),
              _halfDropdown(false),
            ],
          ))
    ]);
  }

  Widget _halfDropdown(bool isLeft) => Container(
    decoration: BoxDecoration(
        borderRadius: (isLeft)
            ? BorderRadius.horizontal(
          left: Radius.circular(10.0),
        )
            : BorderRadius.horizontal(
          right: Radius.circular(10.0),
        ),
        border: Border.all(
          color: Colors.black,
          width: 1,
        )),
    child: DropdownDemo(
      hint: leftHint,
      items: leftItem,
      backgroundColor: backgroundColor,
    ),
  );
}