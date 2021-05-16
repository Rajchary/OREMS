import 'dart:core';

class Person {
  String name = "";
  String mobile = "";
  String email = "";
  String password = "";
  String cpassword = "";
  String occupation = "";
  String get getName => this.name;

  set setName(String name) => this.name = name;

  get getMobile => this.mobile;

  set setMobile(mobile) => this.mobile = mobile;

  get getEmail => this.email;

  set setEmail(email) => this.email = email;

  get getPassword => this.password;

  set setPassword(password) => this.password = password;

  get getCpassword => this.cpassword;

  set setCpassword(cpassword) => this.cpassword = cpassword;

  get getOccupation => this.occupation;

  set setOccupation(occupation) => this.occupation = occupation;
}
