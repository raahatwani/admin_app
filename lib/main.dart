// ignore_for_file: prefer_const_constructors, avoid_print, prefer_typing_uninitialized_variables, non_constant_identifier_names, sized_box_for_whitespace, use_key_in_widget_constructors

import 'package:admin_app/SplashScreen.dart';
import 'package:admin_app/addcultureform.dart';
import 'package:admin_app/adddestinationform.dart';
import 'package:admin_app/addgallery.dart';
import 'package:admin_app/addlibrary.dart';
import 'package:admin_app/addliterature.dart';
import 'package:admin_app/constants.dart';
import 'package:admin_app/handicraftsform.dart';
import 'package:admin_app/loginform.dart';
import 'package:admin_app/mainPageform.dart';
import 'package:admin_app/recipeform.dart';
import 'package:admin_app/viewLibrary.dart';
import 'package:admin_app/viewcuisine.dart';
import 'package:admin_app/viewculture.dart';
import 'package:admin_app/viewdestination.dart';
import 'package:admin_app/viewfeedback.dart';
import 'package:admin_app/viewgallery.dart';
import 'package:admin_app/viewhandicrafts.dart';
import 'package:admin_app/viewliterature.dart';
import 'package:admin_app/viewmain.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    theme: myTheme,
    home: Login(),
    debugShowCheckedModeBanner: false,
  ));
}

var devH, devW, button;
class Home extends StatelessWidget {
   

  @override
  Widget build(BuildContext context) {
    devH = MediaQuery.of(context).size.height;
    devW = MediaQuery.of(context).size.width;
    return SplashScreen();
  }
}
ThemeData myTheme = ThemeData(
  scaffoldBackgroundColor: Color(0xffFBC757),
  primaryColor: Color(0xff00A095),
);


class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
   
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text(
          'Admin Dashboard',
          style: kHeading,
        ),
        centerTitle: true,
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              
              Padding(
                padding: EdgeInsets.all(devH * 0.03),
                child: CircleAvatar(
                    backgroundImage: AssetImage('assets/admin.jpg'),
                    maxRadius: devH * 0.1),
              ),
              Padding(padding: EdgeInsets.all(8.0),child: Text('Welcome Back Admin!',style: kSubHeading,)),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FeedbackButton(FeedBack(), 'User FeedBack',  Icons.remove_red_eye),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SelectionButton(MainCategoryPage(), 'View Main Page',
                        Icons.remove_red_eye),
                    SelectionButton(MainFormData(), 'Add Category',
                        Icons.add_box_rounded),
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
                        BookFormData(), 'Add Book', Icons.add_box_rounded),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SelectionButton(ViewCuisinePage(), 'View Cuisine \n Page',
                        Icons.remove_red_eye),
                    SelectionButton(RecipeFormData(), 'Add Recipie',
                        Icons.add_box_rounded),
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
                        Icons.add_box_rounded),
                  ],
                ),
              ),
             
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SelectionButton(ViewDestination(),
                        'View Destination \n Page', Icons.remove_red_eye),
                    SelectionButton(DestinationFormData(), 'Add Destination',
                        Icons.add_box_rounded),
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
                        Icons.add_box_rounded),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SelectionButton(ViewGallery(),
                        'View Gallery \n Page', Icons.remove_red_eye),
                    SelectionButton(AddGallery(), 'Add Image',
                        Icons.add_box_rounded),
                  ],
                ),),
               Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SelectionButton(ViewLibrary(), 'View Library \n Page',
                        Icons.remove_red_eye),
                    SelectionButton(AddLibrary(), 'Add Library',
                        Icons.add_box_rounded),
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
      child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor:
                  MaterialStatePropertyAll(Theme.of(context).primaryColor)),
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
              Icon(icon,color: myTheme.scaffoldBackgroundColor,weight: 2,)
            ],
          )),
    );

    
  }

  Widget FeedbackButton(var nextPage, String text, IconData icon){
    return Container(
      height: devH * 0.1,
      width: devW * 0.8,
      child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor:
                  MaterialStatePropertyAll(Theme.of(context).primaryColor)),
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
                style: kSubHeading,
              ),
              Icon(icon,color: myTheme.scaffoldBackgroundColor,weight: 2,)
            ],
          )),
    );
  }
}
