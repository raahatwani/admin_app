// ignore_for_file: must_be_immutable, use_key_in_widget_constructors, prefer_const_constructors, body_might_complete_normally_nullable

import 'package:admin_app/constants.dart';
import 'package:flutter/material.dart';

bool validate = false;

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
          validator: (val) {
            if (val!.isEmpty) {
              return 'please fill this field';
            }
          },
          controller: widget.controller,
          decoration: InputDecoration(
              hintText: widget.hintText,
              errorText: validate ? 'Value Can\'t Be Empty' : null,
              hintStyle: TextStyle(fontSize: 20),
              enabledBorder: kBorder,
              focusedBorder: kBorder)),
    );
  }
}



class ObscureTextInput extends StatefulWidget {
  String hintText = '';
  TextEditingController controller = TextEditingController();
  ObscureTextInput({required this.hintText, required this.controller});

  @override
  State<ObscureTextInput> createState() => _ObscureTextInputState();
}

class _ObscureTextInputState extends State<ObscureTextInput> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        obscureText: true,
          validator: (val) {
            if (val!.isEmpty) {
              return 'please fill this field';
            }
          },
          controller: widget.controller,
          decoration: InputDecoration(
              hintText: widget.hintText,
              errorText: validate ? 'Value Can\'t Be Empty' : null,
              hintStyle: TextStyle(fontSize: 20),
              enabledBorder: kBorder,
              focusedBorder: kBorder)),
    );
  }
}