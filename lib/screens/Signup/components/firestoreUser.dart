import 'package:flutter/material.dart';

class UserData {
  String email;
  String name;
  String mobile;
  String occupation;
  String password;
  String paddress;
  String kycdocument;
  String kycid;
  String upi_id;
  String profilePicture;
  double rating;
  double ratingCount;

  UserData({
    @required this.email,
    @required this.name,
    @required this.mobile,
    @required this.occupation,
    @required this.password,
    @required this.paddress,
    @required this.kycdocument,
    @required this.kycid,
    @required this.upi_id,
    @required this.profilePicture,
    @required this.rating,
    @required this.ratingCount,
  });

  UserData.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    name = json['name'];
    occupation = json['occupation'];
    password = json['password'];
    mobile = json['phone'];
    paddress = json['userAddress'];
    kycdocument = json['kycdocument'];
    kycid = json['kycid'];
    rating = json['Rating'];
    ratingCount = json['ratingCount'];
    upi_id = json["upi_id"];
    profilePicture = json["ProfilePicture"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['email'] = this.email;
    data['name'] = this.name;
    data['occupation'] = this.occupation;
    data['password'] = this.password;
    data['phone'] = this.mobile;
    data['kycid'] = this.kycid;
    data['kycdocument'] = this.kycdocument;
    data['userAddress'] = this.paddress;
    data['upi_id'] = this.upi_id;
    data['Rating'] = this.rating;
    data['ratingCount'] = this.ratingCount;
    data["ProfilePicture"] = this.profilePicture;
    return data;
  }
}
