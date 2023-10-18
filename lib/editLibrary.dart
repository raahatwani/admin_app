// ignore_for_file: must_be_immutable, use_key_in_widget_constructors, non_constant_identifier_names, prefer_const_constructors, file_names

import 'package:admin_app/addlibrary.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'addliterature.dart';
import 'editcuisine.dart';

class EditLibraryState extends StatefulWidget {
  String docId='';
   EditLibraryState({required this.docId});

  @override
  State<EditLibraryState> createState() => _EditLibraryStateState();
}

class _EditLibraryStateState extends State<EditLibraryState> {
  TextEditingController NameController = TextEditingController();
  TextEditingController AddressController = TextEditingController();
  TextEditingController urlController = TextEditingController();
  TextEditingController lidController = TextEditingController();
  final formGlobalKey = GlobalKey<FormState>();
  @override
  void initState() {
    FirebaseFirestore.instance
        .collection('addlibrary')
        .doc(widget.docId.toString())
        .get()
        .then((value) => {
              setState(() {
                lidController.text = value['Library-Id'];
                NameController.text = value['LibraryName'];
                AddressController.text = value['LibraryAddress'];
                urlController.text=value['LibraryLocation'];
              })
            });

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
        title: Text("Edit Library"),
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
                  child: Center(
                    child: Form(
              key: formGlobalKey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    EditInput(controller: lidController),
                    EditInput(controller: NameController),
                    EditInput(controller: AddressController),
                    EditInput(controller: urlController),
                    ElevatedButton(
                      style: ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(
                                  Theme.of(context).primaryColor)),
                        onPressed: () {
                          if (formGlobalKey.currentState!.validate()) {
                            FirebaseFirestore.instance
                                .collection('addlibrary')
                                .doc(widget.docId)
                                .update({
                              'Library-Id': lidController.text,
                              'LibraryName': NameController.text,
                              'LibraryAddress': AddressController.text,
                              'LibraryLocation': LocationController.text,
                            }).whenComplete(() {
                              lidController.clear();
                              NameController.clear();
                              AddressController.clear();
                              LocationController.clear();
                              setState(() {
                                showImage = false;
                              });
                              Alert(
                                      context: context,
                                      title: 'Craft Updated Successfully')
                                  .show();
                            });
                          }
                        },
                        child: Text('Submit'))
                  ],
                ),
              )),
                  ),
                ),
            )));
  }
}

