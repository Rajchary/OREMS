import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:online_real_estate_management_system/screens/Tenant/Services/.env.dart';
import 'package:online_real_estate_management_system/screens/Tenant/Services/directionModel.dart';

class DirectionRepositery {
  static const String _baseUrl =
      'https://maps.googleapis.com/maps/api/directions/json?';
  final Dio _dio;
  DirectionRepositery({Dio dio}) : _dio = dio ?? Dio();
  Future<Directions> getDirection({
    @required LatLng origin,
    @required LatLng destination,
  }) async {
    final response = await _dio.get(
      _baseUrl,
      queryParameters: {
        'origin': '${origin.latitude},${origin.longitude}',
        'destination': '${destination.latitude},${destination.longitude}',
        'key': googleAPIKey,
      },
    );
    if (response.statusCode == 200) {
      print(response.data);
      return Directions.fromMap(response.data);
    }
    return null;
  }
}
