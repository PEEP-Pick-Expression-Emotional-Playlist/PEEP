import 'package:flutter/material.dart'
    hide DropdownButton, DropdownMenuItem, DropdownButtonHideUnderline;
import 'custom_dropdown.dart';
import 'package:flutter/cupertino.dart';

class DropdownDemo extends StatefulWidget {
  // TODO: Explain meaning of variable.
  final int value;
  final String hint;
  final String errorText;
  final List<String> items;
  final Function onChanged;
  final Color backgroundColor;

  const DropdownDemo(
      {Key key,
      this.value,
      this.hint,
      this.items,
      this.onChanged,
      this.errorText,
      this.backgroundColor})
      : super(key: key);

  @override
  _DropdownDemoState createState() => _DropdownDemoState();
}

class _DropdownDemoState extends State<DropdownDemo> {
  String _chosenValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 35,
      child: DropdownButtonHideUnderline(
          child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownButton<String>(
                // isExpanded: true,
                iconSize: 0.0,
                value: _chosenValue,
                elevation: 0,

                /// [dropdownColor] is background color of [DropdownMenuItem]
                // TODO: Make [dropdownColor] suitably. Not Colors.grey
                dropdownColor: widget.backgroundColor,
                style: TextStyle(color: Colors.black),
                items:
                    widget.items.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                      value: value,
                      child: Container(
                          alignment: Alignment.center,
                          child: FittedBox(
                              child: Text(
                            value,
                            textAlign: TextAlign.center,
                          ))));
                }).toList(),
                hint: Text(
                  widget.hint,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
                onChanged: (String value) {
                  setState(() {
                    _chosenValue = value;
                  });
                },
              ))),
    );
  }
}
