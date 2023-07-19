import 'package:chatonline/text_composer.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {

  TextComposer(this.sendMessage);

  late Function (String) sendMessage;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Olá'),
        elevation: 0,
      ),
      body: const TextComposer(
          (text){

          }
      ),
    );
  }
}
