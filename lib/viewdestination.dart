// ignore_for_file: prefer_const_constructors, must_be_immutable, use_key_in_widget_constructors, use_build_context_synchronously

import 'package:admin_app/editdestination.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../main.dart';

class ViewDestination extends StatefulWidget {
  const ViewDestination({super.key});

  @override
  State<ViewDestination> createState() => _ViewDestinationState();
}

class _ViewDestinationState extends State<ViewDestination> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Destination"),
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
            stream: FirebaseFirestore.instance.collection('destination').snapshots(),
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
                    name:data['DestName'],
                    category: data['DestCategory'].toString(),
                    description: data['DestDescription'],
                    imagePath: data['DestImage'],
                    id: data['DestId'],
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
              BorderRadius.circular(12.0), // Adjust the radius as needed
        ),
        elevation: 4,
        child: ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Destination'),
              IconButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => EditDestinationPage(id)));
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
              Text("Did:$id"),
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
      await FirebaseFirestore.instance.collection('destination').doc(id).delete();
  }
}
