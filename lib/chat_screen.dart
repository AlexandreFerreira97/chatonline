import 'dart:html';
import 'dart:io';
import 'package:chatonline/text_composer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {

  TextComposer(this.sendMessage);

  final Function ({String text, File imgFile}) sendMessage;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  void _sendMessage({String text, File imgFile}) async {

    Map<String, dynamic> data = {};

    if(imgFile != null){
      StorageUploadTask task = FirebaseStorage.instance.ref().child(
          DateTime.now().millisecondsSinceEpoch.toString()
      ).putFile(imgFile);

      StorageTaskSnapshot taskSnapshot =  await task.onComplete;
      String url = await taskSnapshot.ref.getDownloadURL();
      data['imgUrl'] = url;
    }

    if(text != null) data['text'] = text;

    FirebaseFirestore.instance.collection('messages').add(data);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Olá'),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(child:
            StreamBuilder(
              stream: Firestore.instance.collection('messages').snapshots(),
              builder: (context, snapshot){
                switch(snapshot.connectionState){
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  default:
                    List<DocumentSnaphot> documents = snapshot.data.documents;

                    return ListView.builder(
                      itemCount: document.length,
                      reverse: true,
                      itemBuilder: (context, snapshot){
                        return ListTile(
                          title: Text(documents[index].data['text']),
                        );
                      },
                    );
                }
              },
            ),
          ),
          const TextComposer(
          ),
        ],
      )
    );
  }
}
