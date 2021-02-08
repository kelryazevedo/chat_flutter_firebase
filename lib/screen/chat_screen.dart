import 'package:chat_flutter_firebase/component/chat_message_widget.dart';
import 'package:chat_flutter_firebase/component/text_composer_widget.dart';
import 'package:chat_flutter_firebase/screen/chat_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  ChatController _controller = ChatController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true, // ignorar a barrinha de baixo
      top: true, //ignorar a barrinha de cima
      child: Scaffold(
        appBar: AppBar(
          title: Text("Chat app"),
          centerTitle: true,
          elevation: Theme.of(context).platform == TargetPlatform.iOS
              ? 0.0
              : 4.0, // tipo a sombrinha da appBar
        ),
        body: Column(
          children: [
            Expanded(
                child: StreamBuilder(
                    //tenho que tipar o que eu quero utilizar
                    stream: FirebaseFirestore.instance.collection("messages").snapshots(), // quem ele vai ficar "ouvindo"
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        // verifica a conecao
                        case ConnectionState.none:
                        case ConnectionState.waiting:
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        default:
                          return ListView.builder(
                              reverse: true, // de baixo pra cima  as mais novas
                              itemCount: snapshot.data.docs.length,
                              itemBuilder: (context, index) {
                                List reverseList = snapshot.data.docs.reversed.toList();
                                return ChatMessageWidget(data: reverseList[index].data(),
                                );
                              });
                      }
                    })),
            Divider(
              height: 1.0,
            ),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
              ),
              child: TextComposerWidget(),
            )
          ],
        ),
      ),
    );
  }
}
