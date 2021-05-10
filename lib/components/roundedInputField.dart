import 'package:flutter/material.dart';
import 'package:online_real_estate_management_system/components/textFieldContainer.dart';
import 'package:online_real_estate_management_system/screens/login/components/body.dart';

import '../constants.dart';

class RoundedInputField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;
  RoundedInputField({
    Key key,
    this.hintText,
    this.icon,
    this.onChanged,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          icon: Icon(
            icon,
            color: greenThick,
          ),
          hintText: hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
