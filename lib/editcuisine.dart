// ignore_for_file: prefer_const_constructors, must_be_immutable, use_key_in_widget_constructors, prefer_const_literals_to_create_immutables
import 'package:admin_app/constants.dart';
import 'package:admin_app/main.dart';
import 'package:admin_app/recipeform.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class EditCuisinePage extends StatefulWidget {
  String docId;
  EditCuisinePage(this.docId);

  @override
  State<EditCuisinePage> createState() => _EditCuisinePageState();
}

class _EditCuisinePageState extends State<EditCuisinePage> {
  TextEditingController idController = TextEditingController();
  TextEditingController recipeNameController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController stepsController = TextEditingController();
  TextEditingController imageController = TextEditingController();
  String networkImage = '';
  final formGlobalKey = GlobalKey<FormState>();
  @override
  void initState() {
    FirebaseFirestore.instance
        .collection('recipe')
        .doc(widget.docId.toString())
        .get()
        .then((value) => {
              setState(() {
                idController.text = value['RID'];
                recipeNameController.text = value['RecipeName'];
                descController.text = value['RecipeDescription'];
                stepsController.text = value['Steps'];
                imageController.text = value['RecipeImage'];
                networkImage = value['RecipeImage'];
                selectedLabels = (value['Ingredients'] as List).cast<String>();
              })
            });

    // print(imageController.text);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(appBar: AppBar(
        title: Text("Edit Recipe"),
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
                    EditInput(controller: idController),
                    EditInput(controller: recipeNameController),
                    EditInput(controller: descController),
                    EditInput(controller: stepsController),
                    EditInput(controller: imageController),
                    
                    Container(
                      height: devW * 0.4,
                      width: devW * 0.3,
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(blurRadius: 5, offset: Offset(5, 5))
                          ],
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.black, width: 1),
                          image: DecorationImage(
                              image: NetworkImage(networkImage),
                              fit: BoxFit.fill)),
                    ),
                    ElevatedButton(style: ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(
                                  Theme.of(context).primaryColor)),
                        onPressed: () {
                          if (formGlobalKey.currentState!.validate()) {
                            FirebaseFirestore.instance
                                .collection('recipe')
                                .doc(widget.docId)
                                .update({
                              'ID': idController.text,
                              'RecipeName': recipeNameController.text,
                              'Description': descController.text,
                              'Steps': stepsController.text,
                              'RecipeImage': imageController.text
                            }).whenComplete(() => Alert(
                                        context: context,
                                        title: 'Recipe Updated Successfully')
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

class EditInput extends StatefulWidget {
  TextEditingController controller = TextEditingController();
  EditInput({required this.controller});

  @override
  State<EditInput> createState() => _EditInputState();
}

class _EditInputState extends State<EditInput> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: widget.controller,
        decoration:
            InputDecoration(focusedBorder: kBorder, enabledBorder: kBorder),
      ),
    );
  }
}
