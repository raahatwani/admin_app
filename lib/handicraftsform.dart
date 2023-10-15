// ignore_for_file: must_be_immutable, prefer_const_constructors, use_key_in_widget_constructors, unused_element, unused_local_variable, unnecessary_set_literal, unnecessary_null_comparison, prefer_const_constructors_in_immutables

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../constants.dart';
import 'bookform.dart';

class HandicraftFormData extends StatefulWidget {
  HandicraftFormData({super.key});
  @override
  State<HandicraftFormData> createState() => _HandicraftFormDataState();
}

class _HandicraftFormDataState extends State<HandicraftFormData> {
  List<String> category = [
    'Paper-Mache',
    'Carpets, Rugs amd Mats',
    'Embroidery Work',
    'Copper Work',
    'Wood Carving'
  ];
  String selcategory = 'Paper-Mache';
  final formGlobalKey = GlobalKey<FormState>();
  pickimage() async {
    ImagePicker picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
      Reference referenceRoot = FirebaseStorage.instance.ref();
      Reference refDirImages = referenceRoot.child('images');
      Reference referenceImageToUpload = refDirImages.child(uniqueFileName);
      final uploadTask = await referenceImageToUpload.putFile(imageFile!);
      imageURL = await referenceImageToUpload.getDownloadURL();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
           appBar: AppBar(
        title: Text("Add New Craft"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Container(decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Theme.of(context).scaffoldBackgroundColor,
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              decoration: BoxDecoration(),
              child: Form(
                key: formGlobalKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Select Category',
                          style: kSubHeading,
                        ),
                        DropdownButton(
                          focusColor: Colors.blue,
                          items: category.map((String category) {
                            return DropdownMenuItem(
                              value: category,
                              child: Text(
                                category,
                                style: kNormalTextBold,
                              ),
                            );
                          }).toList(),
                          value: selcategory,
                          onChanged: (String? newvalue) {
                            setState(() {
                              selcategory = newvalue!;
                            });
                          },
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Upload Image',
                          style: kSubHeading,
                        ),
                        IconButton(
                            onPressed: () {
                              pickimage();
                              showImage = true;
                            },
                            icon: Icon(Icons.camera)),
                      ],
                    ),
                    !showImage
                        ? Text('Image not selected')
                        : SizedBox(
                            height: 100,
                            width: 200,
                            child: Image.file(imageFile!),
                          ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                          validator: ValidationBuilder().url().build(),
                          controller: urlController,
                          decoration: InputDecoration(
                              hintText: 'Enter book url',
                              hintStyle: TextStyle(fontSize: 20),
                              enabledBorder: kBorder,
                              focusedBorder: kBorder)),
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(
                                  Theme.of(context).primaryColor)),
                        onPressed: () {
                          if (imageURL == null) {
                            Alert(context: context, title: "Plese upload image");
                          } else if (formGlobalKey.currentState!.validate()) {
                            String hId =
                                DateTime.now().microsecondsSinceEpoch.toString();
                            FirebaseFirestore.instance
                                .collection('handicraft')
                                .doc(hId)
                                .set({
                              'HID': hId,
                              'CraftImage': imageURL,
                              'CraftURL': urlController.text,
                              'Category': selcategory,
                            }).whenComplete(() => {
                                      urlController.clear(),
                                      setState(() {
                                        showImage = false;
                                      }),
                                      selcategory = 'Paper-Mache',
                                      Alert(
                                              context: context,
                                              title:
                                                  'Handicraft Added Successfully')
                                          .show()
                                    });
                          }
                        },
                        child: Text('Submit'))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ));
  }
}
