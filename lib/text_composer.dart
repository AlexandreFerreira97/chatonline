import 'package:flutter/material.dart';

class TextComposer extends StatefulWidget {
  const TextComposer({Key? key}) : super(key: key);

  @override
  State<TextComposer> createState() => TextComposerState();
}

class TextComposerState extends State<TextComposer> {

  final TextEditingController _textController = TextEditingController();

  bool _isComposing = false;

  void _reset(){
    _textController.clear();
    setState(() {
      _isComposing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          IconButton(onPressed: () {
            ImagePicker
          }, icon: const Icon(Icons.photo_camera)),
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: const InputDecoration.collapsed(
                  hintText: 'Enviar uma mensagem'),
              onChanged: (text) {
                setState(() {
                  _isComposing = text.isNotEmpty;
                });
              },
              onSubmitted: (text) {
                widget.sendMessage(text);
                _reset();
              },
            ),
          ),
          IconButton(onPressed: _isComposing ? (){
            widget.sendMessage(_textController.text);
            _reset();
          } : null,
              icon: const Icon(Icons.send)),
        ],
      ),
    );
  }
}
