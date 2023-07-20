import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  const ChatMessage({Key? key, required this.data}) : super(key: key);

  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      child: Row(
        children: [
          CircleAvatar(backgroundImage: NetworkImage(data['senderPhotoUrl'])),
          Expanded(
              child: Column(
            children: [
              Text(
                data['senderName'],
                style: const TextStyle(
                  fontSize: 13.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          )),
        ],
      ),
    );
  }
}
