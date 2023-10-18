// ignore_for_file: must_be_immutable, prefer_const_constructors, use_key_in_widget_constructors, unused_local_variable, body_might_complete_normally_nullable, sized_box_for_whitespace

import 'dart:io';

import 'package:admin_app/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

bool validate=false;
TextEditingController nameController = TextEditingController();
TextEditingController authorController = TextEditingController();
TextEditingController genreController = TextEditingController();
TextEditingController lengthController = TextEditingController();
TextEditingController langController = TextEditingController();
TextEditingController descController = TextEditingController();
TextEditingController urlController = TextEditingController();
ImagePicker picker=ImagePicker();
File? imageFile;
String imageURL='';
final formGlobalKey = GlobalKey<FormState>();
bool showImage= false;
class BookFormData extends StatefulWidget {

  List<String> category = ['Poetry', 'Prose', 'History', 'New'];
  String selcategory = 'Poetry';
  BookFormData({super.key});

  @override
  State<BookFormData> createState() => _BookFormDataState();
}

class _BookFormDataState extends State<BookFormData> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
        title: Text("Add New Book"),
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
                          items: widget.category.map((String category) {
                            return DropdownMenuItem(
                              value: category,
                              child: Text(
                                category,
                                style: kNormalTextBold,
                              ),
                            );
                          }).toList(),
                          value: widget.selcategory,
                          onChanged: (String? newvalue) {
                            setState(() {
                              widget.selcategory = newvalue!;
                            });
                          },
                        ),
                      ],
                    ),
                    TextInput(hintText: 'Title', controller: nameController),
                    TextInput(hintText: 'Author', controller: authorController),
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
                             showImage=true;
                            },
                            icon: Icon(Icons.camera)),
                      ],
                    ),
                    !showImage?Text('Image not selected'):Container(
                      height: 100,
                      width: 100,
                      child: Image.file(imageFile!),
                    ),
                    TextInput(hintText: 'Genre', controller: genreController),
                    TextInput(hintText: 'Length', controller: lengthController),
                    TextInput(hintText: 'Lang', controller: langController),
                    TextInput(hintText: 'Desc', controller: descController),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                          validator: ValidationBuilder().url().build(),
                          controller: urlController,
                          decoration: InputDecoration(
                      hintText: 'Url',
                      errorText: validate ? 'Value Can\'t Be Empty' : null,
                      hintStyle: TextStyle(fontSize: 20),
                      enabledBorder: kBorder,
                      focusedBorder:kBorder)
                      ),
                    ),
                    ElevatedButton(style: ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(
                                  Theme.of(context).primaryColor)),
                          
                        onPressed: () {
                          if(formGlobalKey.currentState!.validate()){
                            String bookId=DateTime.now().microsecondsSinceEpoch.toString();
                            FirebaseFirestore.instance.collection('books').doc(bookId).set({
                              'BID': bookId,
                              'Category': widget.selcategory,
                              'Bookname': nameController.text,
                              'Bookimage': imageURL,
                              'Author': authorController.text,
                              'Genre': genreController.text,
                              'Length': lengthController.text,
                              'Language': langController.text,
                              'Description': descController.text,
                              'Link': urlController.text
                            }).whenComplete(() => {
                              nameController.clear(),
                              authorController.clear(),
                              genreController.clear(),
                              lengthController.clear(),
                              langController.clear(),
                              descController.clear(),
                              urlController.clear(),
                              setState(() {
                                        showImage = false;
                                      }),
                              Alert(context: context,
                              title: 'Book added successfully'
                              ).show()
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
void pickimage() async{
final pickedFile= await picker.pickImage(source: ImageSource.gallery);
String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
if(pickedFile!=null){
  setState(() {
    imageFile=File(pickedFile.path);
  });

}
Reference referenceRoot=FirebaseStorage.instance.ref();
Reference refDirImages= referenceRoot.child('images');
Reference referenceImageToUpload= refDirImages.child(uniqueFileName);
final uploadTask= await referenceImageToUpload.putFile(imageFile!);
imageURL= await referenceImageToUpload.getDownloadURL();
}
}




class TextInput extends StatefulWidget {
  String hintText = '';
  TextEditingController controller = TextEditingController();
  TextInput({required this.hintText, required this.controller});

  @override
  State<TextInput> createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        validator: (value) {
          if(value!.isEmpty){
            return 'Required Field';
          }
        },
          controller: widget.controller,
          decoration: InputDecoration(
              hintText: widget.hintText,
              errorText: validate ? 'Value Can\'t Be Empty' : null,
              hintStyle: TextStyle(fontSize: 20),
              enabledBorder: kBorder,
              focusedBorder:kBorder)),
    );
  }
}