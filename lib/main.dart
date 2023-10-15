// ignore_for_file: prefer_const_constructors, avoid_print, prefer_typing_uninitialized_variables, non_constant_identifier_names, sized_box_for_whitespace

import 'package:admin_app/addcultureform.dart';
import 'package:admin_app/adddestinationform.dart';
import 'package:admin_app/bookform.dart';
import 'package:admin_app/constants.dart';
import 'package:admin_app/craftcarousel.dart';
import 'package:admin_app/handicraftsform.dart';
import 'package:admin_app/loginform.dart';
import 'package:admin_app/mainPageform.dart';
import 'package:admin_app/recipeform.dart';
import 'package:admin_app/viewcarousel.dart';
import 'package:admin_app/viewcuisine.dart';
import 'package:admin_app/viewculture.dart';
import 'package:admin_app/viewdestination.dart';
import 'package:admin_app/viewhandicrafts.dart';
import 'package:admin_app/viewliterature.dart';
import 'package:admin_app/viewmain.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(theme: myTheme,
    home: Login(),
    debugShowCheckedModeBanner: false,
  ));
}
ThemeData myTheme = ThemeData(
  scaffoldBackgroundColor: Color(0xffFBC757),
  primaryColor: Color(0xff00A095),
);
var devH, devW, button;

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    devH = MediaQuery.of(context).size.height;
    devW = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text(
          'Admin Dashboard',
          style: kHeading,
        ),centerTitle: true,
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.all(devH * 0.03),
                child: CircleAvatar(
                    backgroundImage: AssetImage('assets/admin.jpg'),
                    maxRadius: devH * 0.05),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SelectionButton(MainCategoryPage(), 'View Main Page',
                        Icons.remove_red_eye),
                    SelectionButton(
                        MainFormData(), 'Add Category', Icons.add_alert_outlined),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SelectionButton(ViewLiteraturePage(),
                        'View Literature \n Page', Icons.remove_red_eye),
                    SelectionButton(
                        BookFormData(), 'Add Book', Icons.add_alert_outlined),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SelectionButton(ViewCuisinePage(), 'View Cuisine \n Page', Icons.remove_red_eye),
                    SelectionButton(RecipeFormData(), 'Add Recipie',
                        Icons.add_alert_outlined),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SelectionButton(ViewHandicraftPage(),
                        'View Handicraft \n Page', Icons.remove_red_eye),
                    SelectionButton(HandicraftFormData(), 'Add Craft',
                        Icons.add_alert_outlined),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SelectionButton(ViewHandicraftCarousel(),
                        'View Handicraft \n Carousel', Icons.remove_red_eye),
                    SelectionButton(CraftCarousel(), 'Add Craft \n Carousel',
                        Icons.add_alert_outlined),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SelectionButton(ViewDestination(), 'View Destination \n Page',
                        Icons.remove_red_eye),
                    SelectionButton(DestinationFormData(), 'Add Destination',
                        Icons.add_alert_outlined),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SelectionButton(ViewCulture(), 'View Culture \n Page',
                        Icons.remove_red_eye),
                    SelectionButton(CultureFormData(), 'Add Culture',
                        Icons.add_alert_outlined),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }

  Widget SelectionButton(var nextPage, String text, IconData icon) {
    return Container(
      height: devH * 0.1,
      width: devW * 0.4,
      child: ElevatedButton(style: ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(
                                    Theme.of(context).primaryColor)),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => nextPage));
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                text,
                style: kNormalText,
              ),
              Icon(icon)
            ],
          )),
    );
  }
}