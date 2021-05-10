import 'package:flutter/material.dart';
import 'package:online_real_estate_management_system/components/textFieldContainer.dart';

import '../constants.dart';

class RoundedPasswordField extends StatelessWidget {
  final String hintText;
  final IconData sicon, picon;
  final ValueChanged<String> onChanged;
  const RoundedPasswordField({
    Key key,
    this.hintText,
    this.sicon = Icons.visibility,
    this.onChanged,
    this.picon = Icons.lock,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        obscureText: true,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
          icon: Icon(
            picon,
            color: greenThick,
          ),
          suffixIcon: Icon(
            sicon,
            color: greenThick,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
