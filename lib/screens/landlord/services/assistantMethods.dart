import 'package:geolocator/geolocator.dart';
import 'package:online_real_estate_management_system/screens/landlord/services/requestAssistant.dart';
import 'package:online_real_estate_management_system/services/configMaps.dart';

class AssistantMethods {
  static Future<String> searchCordinateAddress(Position position) async {
    String placeAddress = " ";
    String url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey";
    var response = await RequestAssistant.getRequest(url);
    try {
      if (response != 'failed') {
       // print(response);
        placeAddress = response["results"][0]["formatted_address"];
        print("request not failed..::==>>");
      }
    } on Exception catch (e) {
      print("Exception occured");
    }
    return placeAddress;
  }
}
