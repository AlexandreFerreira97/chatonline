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

    if(imgFile != null){
      StorageUploadTask task = FirebaseStorage.instance.ref().child(
          DateTime.now().millisecondsSinceEpoch.toString()
      ).putFile(imgFile);

      StorageTaskSnapshot taskSnapshot =  await task.onComplete;
      String url = await taskSnapshot.ref.getDownloadURL();
    }

    FirebaseFirestore.instance.collection('messages').add({
      'text' : text
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Olá'),
        elevation: 0,
      ),
      body: const TextComposer(
      ),
    );
  }
}
