// ignore_for_file: prefer_const_constructors, must_be_immutable
import 'package:admin_app/bookform.dart';
import 'package:admin_app/editliteraturepage.dart';
import 'package:admin_app/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class EditHanducraftPage extends StatefulWidget {
  String docId;
  EditHanducraftPage(this.docId, {super.key});

  @override
  State<EditHanducraftPage> createState() => _EditHanducraftPageState();
}

class _EditHanducraftPageState extends State<EditHanducraftPage> {
  TextEditingController crafturlController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController hidController = TextEditingController();
  String networkImage = '';
  final formGlobalKey = GlobalKey<FormState>();
  @override
  void initState() {
    FirebaseFirestore.instance
        .collection('handicraft')
        .doc(widget.docId.toString())
        .get()
        .then((value) => {
              setState(() {
                crafturlController.text = value['CraftURL'];
                categoryController.text = value['Category'];
                hidController.text = value['HID'];
                networkImage = value['CraftImage'];
              })
            });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
        title: Text("Edit Craft"),
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
                    EditInput(controller: hidController),
                    Container(
                      height: devW * 0.4,
                      width: devW * 0.3,
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          boxShadow: const [
                            BoxShadow(blurRadius: 5, offset: Offset(5, 5))
                          ],
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.black, width: 1),
                          image: DecorationImage(
                              image: NetworkImage(networkImage),
                              fit: BoxFit.fill)),
                    ),
                    EditInput(controller: crafturlController),
                    ElevatedButton(
                      style: ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(
                                  Theme.of(context).primaryColor)),
                        onPressed: () {
                          if (formGlobalKey.currentState!.validate()) {
                            FirebaseFirestore.instance
                                .collection('handicraft')
                                .doc(widget.docId)
                                .update({
                              'HID': hidController.text,
                              'Category': categoryController.text,
                              'CraftImage': networkImage,
                              'CraftURL': crafturlController.text,
                            }).whenComplete(() {
                              categoryController.clear();
                              crafturlController.clear();
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
