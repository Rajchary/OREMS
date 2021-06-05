import 'package:flutter/material.dart';
import 'package:online_real_estate_management_system/constants.dart';
import 'package:online_real_estate_management_system/screens/Home/homeScreen.dart';
import 'package:online_real_estate_management_system/screens/Home/models/profileView.dart';
import 'package:online_real_estate_management_system/screens/landlord/components/addProperty.dart';
import 'package:online_real_estate_management_system/screens/landlord/components/addfromMap.dart';

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var route = ModalRoute.of(context).settings.name;
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                primary: Colors.black,
              ),
              onPressed: () {
                print(route);
                if (route.toString() != HomeScreen.idScreen)
                  Navigator.pushNamedAndRemoveUntil(
                      context, HomeScreen.idScreen, (route) => false);
              },
              icon: Icon(
                Icons.home,
                color: Colors.white,
                size: 40,
              ),
              label: Text(""),
            ),
            //SizedBox(width: 5),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                primary: Colors.black,
              ),
              onPressed: () {
                print(route);
                if (route.toString() != ProfileView.idScreen)
                  Navigator.pushNamed(context, ProfileView.idScreen);
              },
              icon: Icon(
                Icons.person,
                color: Colors.white,
                size: 40,
              ),
              label: Text(""),
            ),
            SizedBox(width: 5),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                primary: Colors.black,
              ),
              onPressed: () {
                if (route.toString() != AddMyProperty.idScreen)
                  Navigator.pushNamed(context, AddMyProperty.idScreen);
              },
              icon: Icon(
                Icons.add_circle,
                color: greenThick,
                size: 40,
              ),
              label: Text(""),
            ),
            SizedBox(width: 5),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                primary: Colors.black,
              ),
              onPressed: () {
                if (route.toString() != AddMap.idScreen)
                  Navigator.pushNamed(context, AddMap.idScreen);
              },
              icon: Icon(
                Icons.navigation,
                color: Colors.white,
                size: 40,
              ),
              label: Text(""),
            ),
            //SizedBox(width: 5),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                primary: Colors.black,
              ),
              onPressed: () {},
              icon: Icon(
                Icons.settings,
                color: Colors.white,
                size: 40,
              ),
              label: Text(""),
            ),
            // FloatingActionButton(onPressed: onPressed)
          ],
        ),
      ),
    );
  }
}
