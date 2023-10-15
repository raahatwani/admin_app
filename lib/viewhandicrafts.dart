// ignore_for_file: prefer_const_constructors, must_be_immutable, use_key_in_widget_constructors, use_build_context_synchronously


import 'package:admin_app/edithandicraft.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../main.dart';

class ViewHandicraftPage extends StatefulWidget {
  const ViewHandicraftPage({super.key});

  @override
  State<ViewHandicraftPage> createState() => _ViewHandicraftPageState();
}

class _ViewHandicraftPageState extends State<ViewHandicraftPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Handicraft"),
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
            stream: FirebaseFirestore.instance.collection('handicraft').snapshots(),
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
                  return Handicraft(
                    id: data['HID'].toString(),
                    category: data['Category'].toString(),
                    url: data['CraftURL'].toString(),
                    imagePath: data['CraftImage'].toString(),
                  );
                }).toList(),
              );
            }),
      ),
    );
  }
}

class Handicraft extends StatelessWidget {
  final String category;
  final String url;
  final String imagePath;
  String id = '';

  Handicraft(
      {required this.category,
      required this.url,
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
          title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Handicraft'),
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => EditHanducraftPage(id)));
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
              Text("HID:$id"),
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
              Text("CategoryName: $category"),
              Text(
                "CraftURL: $url",
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        ),
      ),
    );
  }
  void deleteBook(BuildContext context) async {
      await FirebaseFirestore.instance.collection('handicraft').doc(id).delete();
  }
}
