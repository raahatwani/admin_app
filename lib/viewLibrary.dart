// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, non_constant_identifier_names, must_be_immutable, file_names

import 'package:admin_app/editLibrary.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ViewLibrary extends StatefulWidget {
  const ViewLibrary({super.key});

  @override
  State<ViewLibrary> createState() => _ViewLibraryState();
}

class _ViewLibraryState extends State<ViewLibrary> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Library"),
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
            stream: FirebaseFirestore.instance.collection('addlibrary').snapshots(),
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
                  return Library(
                    id: data['Library-Id'].toString(),
                    Name: data['LibraryName'].toString(),
                    Address: data['LibraryAddress'].toString(),
                    Location: data['LibraryLocation'].toString(),
                  );
                }).toList(),
              );
            }),
      ),
    );
  }
}

class Library extends StatelessWidget {
  final String Name;
  final String Location;
  final String Address;
  String id = '';

  Library(
      {required this.Name,
      required this.Location,
      required this.Address,
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
          title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Library'),
            
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => EditLibraryState(docId: id,)));
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

              Text("Library-Id:$id"),
             Text("LibraryName:$Name"),
              Text("LibraryAddress: $Address"),
              Text(
                "LibraryLocation: $Location",
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        ),
      ),
    );
  }
  void deleteBook(BuildContext context) async {
      await FirebaseFirestore.instance.collection('addlibrary').doc(id).delete();
  }
}
