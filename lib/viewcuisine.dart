// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, use_build_context_synchronously

import 'package:admin_app/editcuisine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'main.dart';

class ViewCuisinePage extends StatefulWidget {
  const ViewCuisinePage({super.key});

  @override
  State<ViewCuisinePage> createState() => _ViewCuisinePageState();
}

class _ViewCuisinePageState extends State<ViewCuisinePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cuisine"), 
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
            stream: FirebaseFirestore.instance.collection('recipe').snapshots(),
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
                  return MyListTile(
                    rid: data['RID'],
                    rdesc: data['RecipeDescription'],
                    rimage: data['RecipeImage'],
                    rname: data['RecipeName'],
                    rsteps: data['Steps'],
                    ringredients: data['Ingredients'] is String
        ? (data['Ingredients'] as String).split(',')
        : (data['Ingredients'] as List<dynamic>),
                    // ringredients: (data['Ingredients'] as List<dynamic>),
                  );
                }).toList(),
              );
            }),
      ),
    );
  }
}

class MyListTile extends StatelessWidget {
  final String rid;
  final String rdesc;
  final String rimage;
  final String rname;
  final String rsteps;
 final List<dynamic> ringredients;

  MyListTile(
      {required this.rid,
      required this.rdesc,
      required this.rimage,
      required this.rname,
      required this.rsteps,
      required this.ringredients,});

      List getIngredientsList() {
    return ringredients.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(12.0), 
        ),
        elevation: 4,
        child: ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('CUISINE'),
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => EditCuisinePage(rid)));
                  },
                  icon: Icon(Icons.edit)),
                  IconButton(
                      onPressed: (){
                        deleteBook(context);
                      },
                      icon: Icon(Icons.delete),
                    ),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("RId:$rid"),
              Text("RecipeName:$rname"),
              Text("Description:$rdesc"),
              Text("Ingredients:"),
              Column(
                children: ringredients.map((ingredient) {
                  return Text("$ingredient");
                }).toList(),
              ),
              Text("Steps:$rsteps"),
              Text("Image:$rimage"),
              Container(
                height: devW * 0.4,
                width: devW * 0.3,
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    boxShadow: [BoxShadow(blurRadius: 5, offset: Offset(5, 5))],
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Colors.black, width: 1),
                    image: DecorationImage(
                        image: NetworkImage(rimage), fit: BoxFit.fill)),
              ),
            ],
          ),
        ),
      ),
    );
  }
  void deleteBook(BuildContext context) async {
      await FirebaseFirestore.instance.collection('recipe').doc(rid).delete();
}
}