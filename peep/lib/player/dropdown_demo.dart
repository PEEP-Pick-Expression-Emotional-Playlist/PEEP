import 'package:flutter/material.dart'
    hide DropdownButton, DropdownMenuItem, DropdownButtonHideUnderline;
import 'custom_dropdown.dart';
import 'package:flutter/cupertino.dart';

class DropDownDemo extends StatefulWidget {
  final int value;
  final String hint;
  final String errorText;
  final List<String> items;
  final Function onChanged;

  const DropDownDemo(
      {Key key,
      this.value,
      this.hint,
      this.items,
      this.onChanged,
      this.errorText})
      : super(key: key);

  @override
  _DropDownDemoState createState() => _DropDownDemoState();
}

class _DropDownDemoState extends State<DropDownDemo> {
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
                dropdownColor: Colors.grey,
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
