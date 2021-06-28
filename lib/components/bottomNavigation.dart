import 'package:flutter/material.dart';
import 'package:online_real_estate_management_system/assets/CustomeIcons.dart';
import 'package:online_real_estate_management_system/constants.dart';
import 'package:online_real_estate_management_system/screens/Home/Services/postUpiTxn.dart';
import 'package:online_real_estate_management_system/screens/Home/homeScreen.dart';
import 'package:online_real_estate_management_system/screens/Home/models/ClientProfileCheck.dart';
import 'package:online_real_estate_management_system/screens/Home/models/cashFlows.dart';
import 'package:online_real_estate_management_system/screens/Home/models/makePayment.dart';
import 'package:online_real_estate_management_system/screens/Home/models/profileView.dart';
import 'package:online_real_estate_management_system/screens/Home/models/rateUser.dart';
import 'package:online_real_estate_management_system/screens/landlord/components/addProperty.dart';
import 'package:online_real_estate_management_system/screens/landlord/components/addfromMap.dart';

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var route = ModalRoute.of(context).settings.name;
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(
          color: Colors.grey[900],
          style: BorderStyle.solid,
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 5),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            SizedBox(
              width: size.width * 0.07,
            ),
            IconButton(
              onPressed: () {
                if (route.toString() != HomeScreen.idScreen)
                  // Navigator.pushNamedAndRemoveUntil(
                  //     context, HomeScreen.idScreen, (route) => false);
                  Navigator.pop(context);
              },
              icon: Icon(
                Icons.home,
                color: Colors.white,
                size: 40,
              ),
            ),
            SizedBox(
              width: size.width * 0.05,
            ),
            IconButton(
              onPressed: () {
                if (route.toString() != ProfileView.idScreen)
                  Navigator.pushNamed(context, ProfileView.idScreen);
              },
              icon: Icon(
                Icons.person,
                color: Colors.white,
                size: 40,
              ),
            ),
            SizedBox(
              width: size.width * 0.05,
            ),
            IconButton(
              onPressed: () {
                if (route.toString() != AddMyProperty.idScreen)
                  Navigator.pushNamed(context, AddMyProperty.idScreen);
              },
              icon: Icon(
                Icons.add_circle,
                color: greenThick,
                size: 40,
              ),
            ),
            SizedBox(
              width: size.width * 0.05,
            ),
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, CashFlows.idScreen);
              },
              icon: Icon(
                CustomIcons.switch_icon,
                color: Colors.white,
                size: 35,
              ),
            ),
            SizedBox(
              width: size.width * 0.05,
            ),
            IconButton(
              onPressed: () {
                if (route.toString() != RateUser.idScreen)
                  //Navigator.pushNamed(context, AddMap.idScreen);
                  Navigator.pushNamed(context, RateUser.idScreen);
              },
              icon: Icon(
                CustomIcons.rate_review,
                color: Colors.white,
                size: 35,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
