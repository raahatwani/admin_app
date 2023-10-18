// ignore_for_file: must_be_immutable, prefer_const_constructors, use_key_in_widget_constructors, unused_import, unused_field, unused_local_variable, non_constant_identifier_names, sized_box_for_whitespace

import 'dart:io';
import 'package:admin_app/addliterature.dart';
import 'package:admin_app/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:rflutter_alert/rflutter_alert.dart';


String recipeimageURL = '';
TextEditingController recipenamecontroller = TextEditingController();
TextEditingController recipedesccontroller = TextEditingController();
TextEditingController stepscontroller = TextEditingController();
// MultiSelectController ingredientscontroller = MultiSelectController();
String selectedItems = "";
List<String> selectedLabels = [];

class RecipeFormData extends StatefulWidget {
  List<String> category = ['Beverages', 'HomeMade', 'Wazwan', 'Deserts'];
  List<ValueItem> ingredients = [
    ValueItem(label: 'Water', value: '1'),
    ValueItem(label: 'Cardamom'),
    ValueItem(label: 'Cinnamon'),
    ValueItem(label: 'Saffron'),
    ValueItem(
      label: 'Sugar',
    ),
    ValueItem(label: 'Kashhmiri Tea Leaves'),
    ValueItem(label: 'Almonds'),
    ValueItem(label: 'Milk'),
    ValueItem(label: 'Salt'),
    ValueItem(label: 'Baking Soda'),
    ValueItem(label: 'Basil Seeds'),
    ValueItem(label: 'Dry Fruits'),
    ValueItem(label: 'Yogurt'),
    ValueItem(label: 'Dried Mint Leaves'),
    ValueItem(label: 'Cumin Powder'),
    ValueItem(label: 'Carrots'),
    ValueItem(label: 'Mustard Seeds'),
    ValueItem(label: 'Red Chilli Powder'),
    ValueItem(label: 'Black Salt'),
    ValueItem(label: 'Beet Root'),
    ValueItem(label: 'Powdered Jaggery'),
    ValueItem(label: 'Pepper Corns'),
    ValueItem(label: 'Tea Leaves'),
    ValueItem(label: 'Water', value: '1'),
    ValueItem(label: 'Cardamom'),
    ValueItem(label: 'Cinnamon'),
    ValueItem(label: 'Saffron'),
    ValueItem(
      label: 'Sugar',
    ),
    ValueItem(label: 'Kashhmiri Tea Leaves'),
    ValueItem(label: 'Almonds'),
    ValueItem(label: 'Milk'),
    ValueItem(label: 'Salt'),
    ValueItem(label: 'Baking Soda'),
    ValueItem(label: 'Basil Seeds'),
    ValueItem(label: 'Dry Fruits'),
    ValueItem(label: 'Yogurt'),
    ValueItem(label: 'Dried Mint Leaves'),
    ValueItem(label: 'Cumin Powder'),
    ValueItem(label: 'Carrots'),
    ValueItem(label: 'Mustard Seeds'),
    ValueItem(label: 'Red Chilli Powder'),
    ValueItem(label: 'Black Salt'),
    ValueItem(label: 'Beet Root'),
    ValueItem(label: 'Powdered Jaggery'),
    ValueItem(label: 'Pepper Corns'),
    ValueItem(label: 'Tea Leaves'),
    ValueItem(label: 'Rajma'),
    ValueItem(label: 'Onion'),
    ValueItem(label: 'Tomato'),
    ValueItem(label: 'Tomato Puree'),
    ValueItem(label: 'Ginger Garlic Paste'),
    ValueItem(label: 'Asafoetida/Hing'),
    ValueItem(label: 'Dry Ginger Paste'),
    ValueItem(label: 'Cumin'),
    ValueItem(label: 'Bottle Gourd'),
    ValueItem(label: 'Oil'),
    ValueItem(label: 'Yogurt'),
    ValueItem(label: 'Cloves'),
    ValueItem(label: 'Fennel Powder'),
    ValueItem(label: 'Ginger Powder'),
    ValueItem(label: 'Shahi Jeera'),
    ValueItem(label: 'Paneer'),
    ValueItem(label: 'Bay Leaves'),
    ValueItem(label: 'Ground Ginger'),
    ValueItem(label: 'Coriander Powder'),
    ValueItem(label: 'Potatoes'),
    ValueItem(label: 'Maida'),
    ValueItem(label: 'Turmeric Powder'),
    ValueItem(label: 'Spinach'),
    ValueItem(label: 'Chillies'),
    ValueItem(label: 'Garlic'),
    ValueItem(label: 'Brinjals'),
    ValueItem(label: 'Lime'),
    ValueItem(label: 'Cinnamon'),
    ValueItem(label: 'Coriander Powder'),
    ValueItem(label: 'Fish Fillets'),
    ValueItem(label: 'Radish'),
    ValueItem(label: 'Veer'),
    ValueItem(label: 'Saaunf'),
    ValueItem(label: 'Tamarind Pulp'),
    ValueItem(label: 'Mutton'),
    ValueItem(label: 'Mint Leaves'),
    ValueItem(label: 'Kadam'),
    ValueItem(label: 'Badi Elachi'),
    ValueItem(label: 'Choti Elachi'),
    ValueItem(label: 'Ratan Jot'),
    ValueItem(label: 'Meat Fat'),
    ValueItem(label: 'Moval Extract'),
    ValueItem(label: 'Ghee'),
    ValueItem(label: 'Saffron'),
    ValueItem(label: 'Black Pepper Powder'),
    ValueItem(label: 'Egg'),
    ValueItem(label: 'Ginger Paste'),
    ValueItem(label: 'Nutmeg Powder'),
    ValueItem(label: 'Kashmiri Apples'),
    ValueItem(label: 'Nuts'),
    ValueItem(label: 'Fresh Cream'),
    ValueItem(label: 'Maida'),
    ValueItem(label: 'Cardamon Pods'),
    ValueItem(label: 'Sevaiyan'),
    ValueItem(label: 'Khoya'),
    ValueItem(label: 'Rose Petals'),
    ValueItem(label: 'Falooda Sev'),
    ValueItem(label: 'Rose Syrup'),
    ValueItem(label: 'Ice Cream'),
    ValueItem(label: 'Cheese'),
    ValueItem(label: 'Oats'),
    ValueItem(label: 'Poppy Seeds'),
    ValueItem(label: 'Semolina'),
    ValueItem(label: 'Flour'),
  ];
  String selcategory = 'Beverages';
  RecipeFormData({super.key});

  @override
  State<RecipeFormData> createState() => _RecipeFormDataState();
}

class _RecipeFormDataState extends State<RecipeFormData> {
  final formGlobalKey = GlobalKey<FormState>();
  final List<ValueItem> _selectedOptions = [];
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
      recipeimageURL = await referenceImageToUpload.getDownloadURL();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
           appBar: AppBar(
        title: Text("Add New Recipe"),
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
            child: Form(
              key: formGlobalKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('Select Category'),
                  DropdownButton(
                    focusColor: Colors.blue,
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
                      hintText: 'Recipe Name', controller: recipenamecontroller),
                  TextInput(
                      hintText: 'Recipe Description',
                      controller: recipedesccontroller),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MultiSelectDropDown(
                      borderColor: Colors.black,
                      borderWidth: 3,
                      borderRadius: 20,
                      showClearIcon: true,
                      // controller: ingredientscontroller,
                      onOptionSelected: (options) {
                        selectedLabels =
                            options.map((option) => option.label).toList();
                        debugPrint(selectedLabels.toString());
                        selectedItems = options.toString();
                      },
                      searchEnabled: true,
                      options: widget.ingredients,
                      maxItems: 20,
                      selectionType: SelectionType.multi,
                      chipConfig: const ChipConfig(
                          wrapType: WrapType.wrap, backgroundColor: Colors.red),
                      dropdownHeight: 300,
                      optionTextStyle: const TextStyle(fontSize: 16),
                      selectedOptionIcon: const Icon(
                        Icons.check_circle,
                        color: Colors.pink,
                      ),
                      selectedOptionTextColor: Colors.blue,
                    ),
                  ),
                  TextInput(hintText: 'Steps', controller: stepscontroller),
                  ElevatedButton(
                    style: ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(
                                    Theme.of(context).primaryColor)),
                            
                      onPressed: () {
                        if (formGlobalKey.currentState!.validate()) {
                          // print('Helo');
                          String Recipeid =
                              DateTime.now().microsecondsSinceEpoch.toString();
                          FirebaseFirestore.instance
                              .collection('recipe')
                              .doc(Recipeid)
                              .set({
                                'Category':widget.selcategory,
                            'RID': Recipeid,
                            'RecipeName': recipenamecontroller.text,
                            'RecipeImage': recipeimageURL,
                            'RecipeDescription': recipedesccontroller.text,
                            'Ingredients': selectedLabels,
                            'Steps': stepscontroller.text,
                          }).whenComplete(() => {
                                    recipenamecontroller.clear(),
                                    recipedesccontroller.clear(),
                                    stepscontroller.clear(),
                                    setState(() {
                                          showImage = false;
                                          // selectedLabels.remove(selectedItems);
                                        }),
                                    // ingredientscontroller.options.clear(),
                                    Alert(
                                            context: context,
                                            title: 'Recipe Added Successfully')
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
    ));
  }
}