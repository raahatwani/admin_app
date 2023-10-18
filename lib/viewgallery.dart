// // ignore_for_file: prefer_const_constructors, must_be_immutable, use_key_in_widget_constructors, use_build_context_synchronously
// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_const_constructors_in_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ViewGallery extends StatefulWidget {
  const ViewGallery({Key? key}) : super(key: key);

  @override
  State<ViewGallery> createState() => _ViewGalleryState();
}

class _ViewGalleryState extends State<ViewGallery> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Images"),
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
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('gallery').snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading");
            }

            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                return Gallery(
                  id: document.id,
                  url: data['ImageURL'].toString(),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}

class Gallery extends StatelessWidget {
  final String url;
  final String id;

  Gallery({
    required this.url,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0), // Adjust the radius as needed
        ),
        elevation: 4,
        child: ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Gallery'),

              IconButton(
                onPressed: () {
                  deleteGallery(context, id);
                },
                icon: Icon(Icons.delete),
              ),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("ImageId: $id"),
              Image.network(url, fit: BoxFit.fill),
              Text(
                "ImageURL: $url",
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void deleteGallery(BuildContext context, String id) async {
    await FirebaseFirestore.instance.collection('gallery').doc(id).delete();
  }
}
