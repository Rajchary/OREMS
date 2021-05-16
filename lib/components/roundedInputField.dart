import 'package:flutter/material.dart';
import 'package:online_real_estate_management_system/components/textFieldContainer.dart';
import 'package:online_real_estate_management_system/screens/login/components/body.dart';

import '../constants.dart';

class RoundedInputField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;
  final TextEditingController textcontroller;
  final TextInputType textInputType;
  final int lines;
  RoundedInputField({
    Key key,
    this.hintText,
    this.icon,
    this.onChanged,
    this.textcontroller,
    this.textInputType,
    this.lines,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      //height: height,
      child: TextField(
        maxLines: lines,
        onChanged: onChanged,
        controller: textcontroller,
        keyboardType: textInputType,
        decoration: InputDecoration(
          icon: Icon(
            icon,
            color: greenThick,
          ),
          hintText: hintText,
          border: InputBorder.none,
        ),
        style: TextStyle(
          color: greenThick,
          fontSize: 20,
        ),
      ),
    );
  }
}
