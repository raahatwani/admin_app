// ignore_for_file: unnecessary_set_literal, non_constant_identifier_names, unnecessary_null_comparison, unused_element, prefer_const_constructors

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../constants.dart';
import 'addliterature.dart';

List<String> downloadUrls = [];
TextEditingController titleController = TextEditingController();
TextEditingController titleDescController = TextEditingController();
TextEditingController historyController = TextEditingController();
TextEditingController processController = TextEditingController();
TextEditingController steponecontroller = TextEditingController();
TextEditingController steptwoController = TextEditingController();
TextEditingController stepthreeController = TextEditingController();
TextEditingController stepfourController = TextEditingController();
TextEditingController stepfiveController = TextEditingController();
List<File> images = [];

class CraftCarousel extends StatefulWidget {
  const CraftCarousel({super.key});
  @override
  State<CraftCarousel> createState() => _CraftCarouselState();
}

class _CraftCarouselState extends State<CraftCarousel> {
  String image = '';
  String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
  pickimage() async {
    List<XFile> pickedFiles = await ImagePicker().pickMultiImage();
    if (pickedFiles != null) {
      List<Reference> storageReferences = [];
      for (int index = 0; index < 5; index++) {
        XFile pickedFile = pickedFiles[index];
        setState(() {
          File image = File(pickedFile.path);
          images.add(image);
        });

        Reference referenceFileToUpload =
            FirebaseStorage.instance.ref().child('images/$uniqueFileName');
        storageReferences.add(referenceFileToUpload);
      }

      List<UploadTask> uploadTasks = [];
      for (int index = 0; index < 5; index++) {
        File image = images[index];
        Reference referenceFileToUpload = storageReferences[index];
        UploadTask uploadTask = referenceFileToUpload.putFile(image);
        uploadTasks.add(uploadTask);
      }
      await Future.wait(uploadTasks);

      for (int index = 0; index < storageReferences.length; index++) {
        String downloadUrl = await storageReferences[index].getDownloadURL();
        downloadUrls.add(downloadUrl);
      }
    }
  }

  final formGlobalKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
        title: Text("Add New Craft Category"),
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
            child: Container(
              decoration: const BoxDecoration(),
              child: Form(
                key: formGlobalKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextInput(hintText: 'Title', controller: titleController),
                    TextInput(
                        hintText: 'Title Description',
                        controller: titleDescController),
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
                            child: Image.file(images[0]),
                          ),
                    TextInput(hintText: 'History', controller: historyController),
                    TextInput(hintText: 'Process', controller: processController),
                    TextInput(
                        hintText: 'Step One', controller: steponecontroller),
                    !showImage
                        ? Text('Image not selected')
                        : SizedBox(
                            height: 100,
                            width: 200,
                            child: Image.file(images[1]),
                          ),
                    TextInput(
                        hintText: 'Step Two', controller: steptwoController),
                    !showImage
                        ? Text('Image not selected')
                        : SizedBox(
                            height: 100,
                            width: 200,
                            child: Image.file(images[2]),
                          ),
                    TextInput(
                        hintText: 'Step Three', controller: stepthreeController),
                    !showImage
                        ? Text('Image not selected')
                        : SizedBox(
                            height: 100,
                            width: 200,
                            child: Image.file(images[3]),
                          ),
                    TextInput(
                        hintText: 'Step Four', controller: stepfourController),
                    !showImage
                        ? Text('Image not selected')
                        : SizedBox(
                            height: 100,
                            width: 200,
                            child: Image.file(images[4]),
                          ),
                    TextInput(
                        hintText: 'Step Five', controller: stepfiveController),
                    ElevatedButton(
                      style: ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(
                                  Theme.of(context).primaryColor)),
                        onPressed: () {
                          // print('hello');
                          if (formGlobalKey.currentState!.validate()) {
                            // print('hey');
                            String CarouselId =
                                DateTime.now().microsecondsSinceEpoch.toString();
                            // print('object');
                            FirebaseFirestore.instance
                                .collection('craftcarousel')
                                .doc(CarouselId)
                                .set({
                              'ImageURL': downloadUrls.toString(),
                              'CAID': CarouselId,
                              'Title': titleController.text,
                              'TitleDesc': titleDescController.text,
                              'TitleImage': downloadUrls[0].toString(),
                              'History': historyController.text,
                              'Process': processController.text,
                              'StepOne': steponecontroller.text,
                              'StepOneImage': downloadUrls[1].toString(),
                              'StepTwo': steptwoController.text,
                              'StepTwoImage': downloadUrls[2].toString(),
                              'StepThree': stepthreeController.text,
                              'StepThreeImage': downloadUrls[3].toString(),
                              'StepFour': stepfourController.text,
                              'StepFourImage': downloadUrls[4].toString(),
                              'StepFive': stepfiveController.text,
                            }).whenComplete(() => {
                                      // print('ki'),
                                      images.clear(),
                                      titleController.clear(),
                                      titleDescController.clear(),
                                      setState(() {
                                        showImage = false;
                                      }),
                                      historyController.clear(),
                                      processController.clear(),
                                      steponecontroller.clear(),
                                      steptwoController.clear(),
                                      stepthreeController.clear(),
                                      stepfourController.clear(),
                                      stepfiveController.clear(),
                                      Alert(
                                              context: context,
                                              title: 'Craft Added Successfully')
                                          .show()
                                    });
                          }
                        },
                        child: const Text('Submit'))
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
