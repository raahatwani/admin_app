// ignore_for_file: must_be_immutable, prefer_const_constructors, use_key_in_widget_constructors, unused_import, sized_box_for_whitespace, unused_local_variable, file_names, non_constant_identifier_names

import 'dart:io';
import 'package:admin_app/bookform.dart';
import 'package:admin_app/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../main.dart';

String mainimageURL = '';
TextEditingController categorydesccontroller = TextEditingController();

class MainFormData extends StatefulWidget {
  const MainFormData({super.key});

  @override
  State<MainFormData> createState() => _MainFormDataState();
}

class _MainFormDataState extends State<MainFormData> {
  List<String> category = [
    'Literature',
    'Cuisine',
    'Handicraft',
    'Destination',
    'Culture'
  ];
  String selcategory = 'Literature';
  pickimage() async {
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
      mainimageURL = await referenceImageToUpload.getDownloadURL();
    }
  }

  final formGlobalKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text("Add Details to Main Page"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Container(
        decoration: BoxDecoration(
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
            child: Form(
              key: formGlobalKey,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(28.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Select Category'),
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
                          : Container(
                              height: 100,
                              width: 200,
                              child: Image.file(imageFile!),
                            ),
                      TextInput(
                          hintText: 'Category Description',
                          controller: categorydesccontroller),
                      ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(
                                  Theme.of(context).primaryColor)),
                          onPressed: () {
                            if (formGlobalKey.currentState!.validate()) {
                              String Categoryid = DateTime.now()
                                  .microsecondsSinceEpoch
                                  .toString();
                              FirebaseFirestore.instance
                                  .collection('main')
                                  .doc(Categoryid)
                                  .set({
                                'CID': Categoryid,
                                'CategoryName': selcategory,
                                'CategoryImage': mainimageURL,
                                'CategoryDescription':
                                    categorydesccontroller.text,
                              }).whenComplete(() => {
                                        categorydesccontroller.clear(),
                                        setState(() {
                                          showImage = false;
                                        }),
                                        Alert(
                                                context: context,
                                                title:
                                                    'Category Added Successfully')
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
      ),
    ));
  }
}
