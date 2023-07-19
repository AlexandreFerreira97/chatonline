import 'package:flutter/material.dart';

class TextComposer extends StatefulWidget {
  const TextComposer({Key? key}) : super(key: key);

  @override
  State<TextComposer> createState() => TextComposerState();
}

class TextComposerState extends State<TextComposer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.photo_camera)),
          const Expanded(
            child: TextField(
              decoration:
                  InputDecoration.collapsed(hintText: 'Enviar uma mensagem'),
            ),
          ),
        ],
      ),
    );
  }
}
