// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, unused_local_variable, use_key_in_widget_constructors, sized_box_for_whitespace

import 'dart:io';

import 'package:admin_app/addliterature.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'constants.dart';
String GalleryimageURL = '';


class AddGallery extends StatefulWidget {
  @override
  State<AddGallery> createState() => _AddGalleryState();
}

class _AddGalleryState extends State<AddGallery> {

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
      GalleryimageURL = await referenceImageToUpload.getDownloadURL();
    }
  }
  final formGlobalKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
           appBar: AppBar(
        title: Text("Add Images"),
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
            child: 
            Form(
              key: formGlobalKey,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
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
                      ElevatedButton(
                        style: ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(
                                    Theme.of(context).primaryColor)),
                            
                          onPressed: () {
                            if (formGlobalKey.currentState!.validate()) {
                              String ImageId = DateTime.now()
                                  .microsecondsSinceEpoch
                                  .toString();
                              FirebaseFirestore.instance
                                  .collection('gallery')
                                  .doc(ImageId)
                                  .set({
                                'Image-Id': ImageId,
                                'ImageURL': GalleryimageURL,                            
                                
                              }).whenComplete(() => {
                                       
                                        setState(() {
                                          showImage=false;
                                        }),
                                        Alert(
                                                context: context,
                                                title:
                                                    'Image Added Successfully')
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