import 'package:flutter/material.dart';
import 'package:online_real_estate_management_system/constants.dart';
import 'package:online_real_estate_management_system/screens/Home/homeScreen.dart';
import 'package:online_real_estate_management_system/screens/landlord/components/addProperty.dart';

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(
          color: Colors.grey[900],
          style: BorderStyle.solid,
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              primary: Colors.black,
            ),
            onPressed: () {
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
            onPressed: () {},
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
              Navigator.pushNamedAndRemoveUntil(
                  context, AddMyProperty.idScreen, (route) => false);
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
            onPressed: () {},
            icon: Icon(
              Icons.navigation,
              color: Colors.grey,
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
    );
  }
}
