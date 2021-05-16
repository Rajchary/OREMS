import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:online_real_estate_management_system/components/progressDialog.dart';
import 'package:online_real_estate_management_system/constants.dart';
import 'package:path/path.dart' as Path;

class AddImages extends StatefulWidget {
  static const String idScreen = "addImageScreen";
  @override
  _AddImagesState createState() => _AddImagesState();
}

class _AddImagesState extends State<AddImages> {
  CollectionReference imgref;
  firebase_storage.Reference propertyDatabase;
  List<File> _image = [];
  final picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add images"),
        actions: [
          TextButton(
            onPressed: () {
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return ProgressDialog(
                      message: "Uploading..",
                    );
                  });
              uploadFile().whenComplete(() => Navigator.of(context).pop());
              Fluttertoast.showToast(msg: "Upload done");
            },
            child: Text(
              "Upload",
              style: TextStyle(color: Colors.black, fontSize: 17),
            ),
          ),
        ],
      ),
      body: GridView.builder(
          itemCount: _image.length + 1,
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
          itemBuilder: (context, index) {
            return index == 0
                ? Center(
                    child: IconButton(
                      icon: Icon(
                        Icons.add_a_photo_rounded,
                        color: greenThick,
                        size: 35,
                      ),
                      onPressed: () {
                        chooseImage();
                      },
                    ),
                  )
                : Container(
                    margin: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: FileImage(_image[index - 1]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
          }),
    );
  }

  chooseImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _image.add(File(pickedFile?.path));
      print(pickedFile.path);
    });
    if (pickedFile.path == null) retrieveLostData();
  }

  Future<void> retrieveLostData() async {
    final LostData response = await picker.getLostData();
    if (response.isEmpty) return;
    if (response.file != null) {
      setState(() {
        _image.add(File(response.file.path));
        print(response.file.path);
      });
    } else
      print(response.file);
  }

  Future uploadFile() async {
    String uid = FirebaseAuth.instance.currentUser.uid;
    for (var img in _image) {
      propertyDatabase = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('images/profiles/$uid');
      await propertyDatabase.putFile(img).whenComplete(() async {
        await propertyDatabase.getDownloadURL().then((value) {
          imgref.add({'url': value});
        });
      });
    }
  }

//{Path.basename(img.path)}
  @override
  void initState() {
    super.initState();
    imgref = FirebaseFirestore.instance.collection('profileURLs');
  }
}
