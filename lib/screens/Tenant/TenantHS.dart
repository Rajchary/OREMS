import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TenantScreen extends StatefulWidget {
  static const idScreen = "tenantScreen";
  const TenantScreen({Key key}) : super(key: key);

  @override
  _TenantScreenState createState() => _TenantScreenState();
}

class _TenantScreenState extends State<TenantScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: SvgPicture.asset(
        "assets/images/growth 2.svg",
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
      )),
    );
  }
}
