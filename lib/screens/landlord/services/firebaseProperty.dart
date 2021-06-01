import 'package:flutter/material.dart';

class Property {
  String propertyName;
  String propertyAddress;
  String propertyDiscription;

  Property({
    @required this.propertyName,
    @required this.propertyDiscription,
    @required this.propertyAddress,
  });
  Property.fromJson(Map<String, dynamic> json) {
    propertyName = json['name'];
    propertyAddress = json['Address'];
    propertyDiscription = json['Discription'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['name'] = this.propertyName;
    data['Address'] = this.propertyAddress;
    data['Discription'] = this.propertyDiscription;
    return data;
  }
}
