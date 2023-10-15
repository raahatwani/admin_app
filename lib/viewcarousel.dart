// ignore_for_file: prefer_const_constructors, must_be_immutable, use_key_in_widget_constructors, non_constant_identifier_names

import 'package:admin_app/edithandicraft.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import 'craftcarousel.dart';

class ViewHandicraftCarousel extends StatefulWidget {
  const ViewHandicraftCarousel({super.key});

  @override
  State<ViewHandicraftCarousel> createState() => _ViewHandicraftCarouselState();
}

class _ViewHandicraftCarouselState extends State<ViewHandicraftCarousel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold( appBar: AppBar(
        title: Text("Carousel"), 
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
        child: StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance.collection('craftcarousel').snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }
          
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text("Loading");
              }
              return ListView(
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;
                  return HandicraftCarousel(
                    id: data['CAID'],
                    title: data['Title'],
                    titledesc: data['TitleDesc'],
                    imagePath: downloadUrls,
                    history: data['History'],
                    process: data['Process'],
                    stepone: data['StepOne'],
                    steptwo: data['StepTwo'],
                    stepthree: data['StepThree'],
                    stepfour: data['StepFour'],
                    stepfive: data['StepFive'],
                  );
                }).toList(),
              );
            }),
      ),
    );
  }
}

class HandicraftCarousel extends StatelessWidget {
  final String title,
      titledesc,
      history,
      process,
      stepone,
      steptwo,
      stepthree,
      stepfour,
      stepfive;
  List<String> imagePath;
  String id = '';

  HandicraftCarousel({
    required this.id,
    required this.title,
    required this.titledesc,
    required this.history,
    required this.process,
    required this.stepone,
    required this.steptwo,
    required this.stepthree,
    required this.stepfour,
    required this.stepfive,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(12.0), // Adjust the radius as needed
        ),
        elevation: 4,
        child: ListTile(
          title: Row(
            children: [
              Text('Carousel'),
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => EditHanducraftPage(id)));
                  },
                  icon: Icon(Icons.edit))
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("CAID:$id"),
              Text("Title: $title"),
              Text("TitleDesc: $titledesc"),
              Image(image: imagePath[0]),
              Text('History'),
              Text("History: $titledesc"),
              Text('Process'),
              Text("Process: $titledesc"),
              Text("StepOne: $titledesc"),
              Image(image: imagePath[1]),
              Text("StepTwo: $titledesc"),
              Image(image: imagePath[2]),
              Text("StepThree: $titledesc"),
              Image(image: imagePath[3]),
              Text("StepFour: $titledesc"),
              Image(image: imagePath[4]),
              Text("StepFive: $titledesc"),
            ],
          ),
        ),
      ),
    );
  }

  Widget Image({required String image}) {
    return Container(
      height: devW * 0.4,
      width: devW * 0.3,
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
          boxShadow: const [BoxShadow(blurRadius: 5, offset: Offset(5, 5))],
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Colors.black, width: 1),
          image: DecorationImage(image: NetworkImage(image), fit: BoxFit.fill)),
    );
  }
}
