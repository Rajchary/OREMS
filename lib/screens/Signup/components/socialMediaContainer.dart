import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:online_real_estate_management_system/constants.dart';

class SocialMediaContainer extends StatelessWidget {
  final String iconSrc;
  final Function press;
  const SocialMediaContainer({
    Key key,
    this.iconSrc,
    this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(width: 2, color: greenThick),
          shape: BoxShape.circle,
        ),
        child: SvgPicture.asset(
          iconSrc,
          color: Colors.deepOrange,
          height: 20,
          width: 20,
        ),
      ),
    );
  }
}
