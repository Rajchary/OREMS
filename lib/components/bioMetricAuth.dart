import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_auth/local_auth.dart';
import 'package:online_real_estate_management_system/screens/Home/homeScreen.dart';

class BioAuth extends StatefulWidget {
  static const idScreen = "FingerPrint";
  const BioAuth({Key key}) : super(key: key);

  @override
  _BioAuthState createState() => _BioAuthState();
}

class _BioAuthState extends State<BioAuth> {
  LocalAuthentication auth = LocalAuthentication();
  bool _canCheckBioMetric;
  List<BiometricType> _availableBiometrics;
  String authorized = "Not Authorized";

  Future<void> _checkBioMetric() async {
    bool canCheckBioMetric;
    try {
      canCheckBioMetric = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      //  print(e);
    }
    if (!mounted) return;
    setState(() {
      _canCheckBioMetric = canCheckBioMetric;
    });
  }

  Future<void> _getAvailableBioMetrics() async {
    List<BiometricType> availableBioMetrics;
    try {
      availableBioMetrics = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print(e);
    }
    setState(() {
      _availableBiometrics = availableBioMetrics;
    });
  }

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      authenticated = await auth.authenticate(
        localizedReason:
            "Provide your Pin or Pattern or FingerPrint to access the HUBBLE",
        useErrorDialogs: true,
        stickyAuth: true,
        biometricOnly: true,
      );
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;
    setState(() {
      authorized = authenticated ? "Authorized Successfully" : "Not Authorized";
      if (authenticated) {
        Navigator.pushNamedAndRemoveUntil(
            context, HomeScreen.idScreen, (route) => false);
        auth.stopAuthentication();
        //dispose();
      }
      // print(authorized);
    });
  }

  @override
  void initState() {
    super.initState();
    _checkBioMetric();
    _getAvailableBioMetrics();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (authorized != "Authorized Successfully") _authenticate();
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFF3C3E52),
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 24, horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  "Authenticate !",
                  style: GoogleFonts.rajdhani(
                    textStyle: Theme.of(context).textTheme.headline4,
                    color: Colors.teal,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 50),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      "assets/images/Fingerprint.svg",
                      width: 250,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Authenticate yourself using Bio-Metric",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.rajdhani(
                        textStyle: Theme.of(context).textTheme.headline4,
                        color: Colors.teal,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 15),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(primary: Colors.blue),
                      onPressed: () async {
                        _authenticate();
                      },
                      icon: Icon(Icons.fingerprint),
                      label: Text(
                        "Authenticate",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
