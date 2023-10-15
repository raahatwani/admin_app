// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, use_build_context_synchronously
import 'package:admin_app/editliteraturepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'main.dart';

class ViewLiteraturePage extends StatefulWidget {
  const ViewLiteraturePage({super.key});

  @override
  State<ViewLiteraturePage> createState() => _ViewLiteraturePageState();
}

class _ViewLiteraturePageState extends State<ViewLiteraturePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Literature"), 
        
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
            stream: FirebaseFirestore.instance.collection('books').snapshots(),
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
                    bookName: data['Bookname'],
                    author: data['Author'],
                    id: data['BID'],
                    image: data['Bookimage'],
                    category: data['Category'],
                    description: data['Description'],
                    genre: data['Genre'],
                    language: data['Language'],
                    length: data['Length'],
                    url: data['Link'],
                  );
                }).toList(),
              );
            }),
      ),
    );
  }
}

class MyListTile extends StatelessWidget {
  final String bookName;
  final String author;
  final String genre;
  final String length;
  final String language;
  final String description;
  final String url;
  final String image;
  final String category;
  final String id;

  MyListTile(
      {required this.bookName,
      required this.author,
      required this.genre,
      required this.category,
      required this.description,
      required this.id,
      required this.image,
      required this.language,
      required this.length,
      required this.url});

      

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
              Text('LITERATURE'),
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => EditLiteraturePage(id)));
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
              Text("Author:$author"),
              Text("Genre: $genre"),
              Text("Language: $language"),
              Text("Length: $length"),
              Text("Id: $id"),
              Text("Name: $bookName"),
              Text("Image: $image"),
              Container(
                height: devW * 0.4,
                width: devW * 0.3,
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    boxShadow: [BoxShadow(blurRadius: 5, offset: Offset(5, 5))],
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Colors.black, width: 1),
                    image: DecorationImage(
                        image: NetworkImage(image), fit: BoxFit.fill)),
              ),
              Text("Link:$url"),
              Text(
                "Description: $description",
                textAlign: TextAlign.justify,
              ),
              Text("Category: $category"),
            ],
          ),
        ),
      ),
    );
  }
  void deleteBook(BuildContext context) async {
      await FirebaseFirestore.instance.collection('books').doc(id).delete();
  }
}
