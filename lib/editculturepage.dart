// ignore_for_file: prefer_const_constructors, must_be_immutable
import 'package:admin_app/editliteraturepage.dart';
import 'package:admin_app/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class EditCulturePage extends StatefulWidget {
  String docId;
  EditCulturePage(this.docId, {super.key});

  @override
  State<EditCulturePage> createState() => _EditCulturePageState();
}

class _EditCulturePageState extends State<EditCulturePage> {
  TextEditingController namecontroller = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController imageController = TextEditingController();
  String networkImage = '';
  final formGlobalKey = GlobalKey<FormState>();
  @override
  void initState() {
    FirebaseFirestore.instance
        .collection('culture')
        .doc(widget.docId.toString())
        .get()
        .then((value) => {
              setState(() {
               namecontroller.text = value['CultureName'];
                descController.text = value['CultureDescription'];
                imageController.text=value['CultureImage'];
                networkImage = value['CultureImage'];
              })
            });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(appBar: AppBar(
        title: Text("Edit Culture"),
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
                  child: Center(
                    child: Form(
              key: formGlobalKey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    EditInput(controller: namecontroller),
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
                    EditInput(controller: descController),
                    ElevatedButton(
                      style: ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(
                                    Theme.of(context).primaryColor)),
                        onPressed: () {
                          if (formGlobalKey.currentState!.validate()) {
                            FirebaseFirestore.instance
                                .collection('culture')
                                .doc(widget.docId)
                                .update({
                                  'CultureName': namecontroller.text,
                                  'CultureImage': imageController.text,
                                  'CultureDescription':descController.text,
                              
                            }).whenComplete(() => Alert(
                                        context: context,
                                        title: 'Destination Updated Successfully')
                                    .show());
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
