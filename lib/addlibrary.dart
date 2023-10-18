// ignore_for_file: prefer_const_constructors, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'addliterature.dart';
import 'constants.dart';

TextEditingController LibraryController = TextEditingController();
TextEditingController addressController = TextEditingController();
TextEditingController LocationController = TextEditingController();

class AddLibrary extends StatefulWidget {
  const AddLibrary({super.key});

  @override
  State<AddLibrary> createState() => _AddLibraryState();
}

class _AddLibraryState extends State<AddLibrary> {
  final formGlobalKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Text("Add New Library"),
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
                    padding: EdgeInsets.all(8.0),
                    child: Form(
                      key: formGlobalKey,
                      child: Column(
                        children: [
                          TextInput(
                            hintText: 'Library Name',
                            controller: LibraryController,
                          ),
                          TextInput(
                              hintText: 'Address',
                              controller:addressController),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                                        validator: ValidationBuilder().url().build(),
                                                        controller: LocationController,
                                                        decoration: InputDecoration(
                                hintText: 'Enter url of location',
                                hintStyle: TextStyle(fontSize: 20),
                                enabledBorder: kBorder,
                                focusedBorder: kBorder)),
                              ),
                          ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStatePropertyAll(
                                      Theme.of(context).primaryColor)),
                              onPressed: () {
                                if (formGlobalKey.currentState!.validate()) {
                              String LibraryId = DateTime.now()
                                  .microsecondsSinceEpoch
                                  .toString();
                              FirebaseFirestore.instance
                                  .collection('addlibrary')
                                  .doc(LibraryId)
                                  .set({
                                'Library-Id': LibraryId,
                                'LibraryName':LibraryController.text,
                                'LibraryAddress':addressController.text, 
                                    'LibraryLocation' :LocationController.text                        
                                                             }).whenComplete(() => {
                                      LibraryController.clear(),
                                      addressController.clear(),
                                      LocationController.clear(),
                                        Alert(
                                                context: context,
                                                title:
                                                    'Library Added Successfully')
                                            .show()
                                      });
                            }
                              },
                              child: Text('Submit'))
                        ],
                      ),
                    )),
              ),
            )));
  }
}



// class TextInput extends StatefulWidget {
//   String hintText = '';
//   TextEditingController controller = TextEditingController();
//  TextInput({required this. hintText, required this. controller});

//   @override
//   State<TextInput> createState() => _TextInputState();
// }

// class _TextInputState extends State<TextInput> {
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: TextFormField(
//         validator: (value) {
//           if(value!.isEmpty){
//             return 'Required Field';
//           }
//         },
//           controller: widget.controller,
//           decoration: InputDecoration(
//               hintText: widget.hintText,
//               errorText: validate ? 'Value Can\'t Be Empty' : null,
//               hintStyle: TextStyle(fontSize: 20),
//               enabledBorder: kBorder,
//               focusedBorder:kBorder)),
//     );
//   }
// }