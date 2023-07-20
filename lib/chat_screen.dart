import 'dart:html';
import 'dart:io';
import 'package:chatonline/chat_message.dart';
import 'package:chatonline/text_composer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ChatScreen extends StatefulWidget {

  TextComposer(this.sendMessage);

  final Function ({String text, File imgFile}) sendMessage;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  final GoogleSignIn googleSignIn = GoogleSignIn();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  FirebaseUser _currentUser;

  @override
  void initSate() {
    super.initState();

    FirebaseAuth.instance.onAuthStateChanged.listen((user){
      setState(() {
        _currentUser = user;
      });
    });
  }

  void _getUser() async {
    try{
      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken,
      );

      final AuthResult authResult = await FirebaseAuth.instance.signInWithCredential(credential);

      final FirebaseUser user = authResult.user;

      return user;
    } catch(e){
      return null;
    }
  }

  Future<FirebaseUser> _sendMessage({String text, File imgFile}) async {

    if(_currentUser != null) return _currentUser;

    final FirebaseUser user = await _getUser();

    if(user == null){
      _scaffoldKey.currentState.showSnackbar(
        const SnackBar(content:  Text('Não foi possiível fazer o login, tente de novo.')),
      );
    }

    Map<String, dynamic> data = {
      'uid': user.uid,
      'senderName': user.displayName,
      'senderPhotoUrl': user.PhotoUrl,
      'time' : Timestamp.now(),
    };

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
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(_currentUser != null ? 'Olá, ${_currentUser.dilplayName}' : 'Chat App'),
        centerTitle: true,
        elevation: 0,
        actions: [
          _currentUser != null ? const IconButton(icon: Icon(Icons.exit_to_app),
            onPressed: () {
              FirebaseAuth.instance.signOut();
              googleSignIn.signOut();
              _scaffoldKey.currentState.showSnackbar(
                const SnackBar(content:  Text('Você saiu com sucesso.')),
              );
            },),
        ],
      ),
      body: Column(
        children: [
          Expanded(child:
            StreamBuilder(
              stream: Firestore.instance.collection('messages').orderBy('time').snapshots(),
              builder: (context, snapshot){
                switch(snapshot.connectionState){
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  default:
                    List<DocumentSnapshot> documents = snapshot.data.documents;

                    return ListView.builder(
                      itemCount: document.length,
                      reverse: true,
                      itemBuilder: (context, snapshot){
                        return ChatMessage(documents[index].data as Map<String, dynamic>),
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
