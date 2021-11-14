import 'package:flutter/material.dart';

import 'dropdown_demo.dart';

class TwoStickyBorderDropdown extends StatelessWidget {
  final String leftHint;
  final String rightHint;
  final List<String> leftItem;
  final List<String> rightItem;
  final Color backgroundColor;
  final Function leftOnChanged;
  final Function rightOnChanged;

  const TwoStickyBorderDropdown(
      {Key key,
      this.leftHint,
      this.rightHint,
      this.leftItem,
      this.rightItem,
      this.backgroundColor,
      this.leftOnChanged,
      this.rightOnChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Padding(
          padding: EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            children: [
              _halfDropdown(true, leftOnChanged),
              _halfDropdown(false, rightOnChanged),
            ],
          ))
    ]);
  }

  Widget _halfDropdown(bool isLeft, Function onChanged) => Container(
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
          hint: isLeft? leftHint:rightHint,
          items: isLeft? leftItem:rightItem,
          backgroundColor: backgroundColor,
          onChanged: (String val) {
            onChanged(val);
          },
        ),
      );
}
