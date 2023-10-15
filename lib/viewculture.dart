// ignore_for_file: prefer_const_constructors, must_be_immutable, use_key_in_widget_constructors, use_build_context_synchronously, unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import 'editculturepage.dart';

class ViewCulture extends StatefulWidget {
  const ViewCulture({super.key});

  @override
  State<ViewCulture> createState() => _ViewCultureState();
}

class _ViewCultureState extends State<ViewCulture> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Culture"), 
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
            stream: FirebaseFirestore.instance.collection('culture').snapshots(),
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
                  return MainTile(
                    name:data['CultureName'],
                    category: data['CultureCategory'].toString(),
                    description: data['CultureDescription'],
                    imagePath: data['CultureImage'],
                    id: data['Culture-Id'],
                  );
                }).toList(),
              );
            }),
      ),
    );
  }
}

class MainTile extends StatelessWidget {
  final String name;
  final String category;
  final String description;
  final String imagePath;
  String id = '';

  MainTile(
      {required this.name,
      required this.category,
      required this.description,
      required this.imagePath,
      required this.id});

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
              Text('Culture'),
              IconButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => EditCulturePage(id)));
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
              Text("Cid:$id"),
               Text("Category: $category"),
             Text("Name: $name"),
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
                        image: NetworkImage(imagePath), fit: BoxFit.fill)),
              ),
              Text(
                "Description: $description",
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        ),
      ),
    );
  }
  void deleteBook(BuildContext context) async {
      await FirebaseFirestore.instance.collection('culture').doc(id).delete();
  }}