import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  runApp(const MyApp());

  QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('mensagens').get();
  snapshot.docs.forEach((d) {
    print(d.data);
  });

}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter',
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      home: Container(),
    );
  }
}




