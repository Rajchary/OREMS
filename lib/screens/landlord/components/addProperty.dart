import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:online_real_estate_management_system/components/bottomNavigation.dart';
import 'package:online_real_estate_management_system/components/confirmDialog.dart';
import 'package:online_real_estate_management_system/components/roundedInputField.dart';
import 'package:online_real_estate_management_system/constants.dart';
import 'package:online_real_estate_management_system/screens/Home/homeScreen.dart';
import 'package:online_real_estate_management_system/screens/landlord/components/addImages.dart';

class AddMyProperty extends StatefulWidget {
  static const String idScreen = "addProperty";

  @override
  _AddMyPropertyState createState() => _AddMyPropertyState();
}

class _AddMyPropertyState extends State<AddMyProperty> {
  TextEditingController propertyNameController = new TextEditingController();

  TextEditingController propertyAddressController = new TextEditingController();

  TextEditingController propertyDiscriptionController =
      new TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.maybeOf(context).size;
    return Scaffold(
      body: AddProperty(
        size: size,
        propertyNameController: propertyNameController,
        propertyAddressController: propertyAddressController,
        propertyDiscriptionController: propertyDiscriptionController,
      ),
      bottomNavigationBar: BottomNavigation(),
    );
  }
}

class AddProperty extends StatelessWidget {
  const AddProperty({
    Key key,
    @required this.size,
    @required this.propertyNameController,
    @required this.propertyAddressController,
    @required this.propertyDiscriptionController,
  }) : super(key: key);

  final Size size;
  final TextEditingController propertyNameController;
  final TextEditingController propertyAddressController;
  final TextEditingController propertyDiscriptionController;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        height: size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue[400],
              Colors.blue[900],
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 25),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(height: 50),
              Text(
                "Fill details about your property",
                style: GoogleFonts.rajdhani(
                  textStyle: Theme.of(context).textTheme.headline4,
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 25,
              ),
              RoundedInputField(
                lines: 2,
                hintText: "property name",
                icon: Icons.home,
                onChanged: (value) {},
                textInputType: TextInputType.text,
                textcontroller: propertyNameController,
              ),
              SizedBox(
                height: 25,
              ),
              RoundedInputField(
                lines: 5,
                hintText: "Property adress",
                icon: Icons.message_sharp,
                onChanged: (value) {},
                textInputType: TextInputType.text,
                textcontroller: propertyAddressController,
              ),
              SizedBox(
                height: 25,
              ),
              RoundedInputField(
                lines: 5,
                hintText: "Discription about the property",
                icon: Icons.add,
                onChanged: (value) {},
                textInputType: TextInputType.text,
                textcontroller: propertyDiscriptionController,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  //SizedBox(width: 25),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final action = await AlertDialogs.confirmDialog(
                          context,
                          "Discard ?",
                          "The changes you have made will not be saved");
                      if (action == DialogAction.Yes) {
                        Navigator.pushNamedAndRemoveUntil(
                            context, HomeScreen.idScreen, (route) => false);
                        Fluttertoast.showToast(msg: "Opertion cancelled.");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red[400],
                    ),
                    icon: Icon(Icons.cancel),
                    label: Text(
                      "Cancel",
                      style: GoogleFonts.rajdhani(
                        textStyle: Theme.of(context).textTheme.headline4,
                        color: Colors.white,
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: 35),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final action = await AlertDialogs.confirmDialog(context,
                          "Proceed ?", "Make sure the details are valid");
                      if (action == DialogAction.Yes) {
                        Navigator.pushNamedAndRemoveUntil(
                            context, AddImages.idScreen, (route) => false);
                        Fluttertoast.showToast(msg: "Select Location.");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: greenThick,
                    ),
                    icon: Icon(Icons.arrow_right),
                    label: Text(
                      "Proceed",
                      style: GoogleFonts.rajdhani(
                        textStyle: Theme.of(context).textTheme.headline4,
                        color: Colors.white,
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
