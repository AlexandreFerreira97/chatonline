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
          Expanded(
            child: TextField(
              decoration: const InputDecoration.collapsed(
                  hintText: 'Enviar uma mensagem'),
              onChanged: (text) {},
              onSubmitted: (text) {},
            ),
          ),
          IconButton(onPressed: (){}, icon: const Icon(Icons.send)),
        ],
      ),
    );
  }
}
