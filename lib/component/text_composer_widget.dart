import 'dart:io';
import 'package:chat_flutter_firebase/screen/chat_controller.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class TextComposerWidget extends StatefulWidget {
  @override
  _TextComposerWidgetState createState() => _TextComposerWidgetState();
}

class _TextComposerWidgetState extends State<TextComposerWidget> {
  bool _isComposing = false;
  final _textController = TextEditingController();
  ChatController _controller = ChatController();

  void _reset() {
    _textController.clear();
    setState(() {
      _isComposing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconTheme(
        data: IconThemeData(color: Theme.of(context).accentColor),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey[200]))),
          child: Row(
            children: [
              Container(
                child: IconButton(
                  icon: Icon(Icons.photo_camera),
                  onPressed: () async {
                    await _controller.ensureLoggedIn();
                    var pickedFile = await ImagePicker().getImage(source: ImageSource.camera);
                    File _image = File(pickedFile.path);
                    if (_image == null) return null;
                    UploadTask  uploadTask =  FirebaseStorage.instance.ref().child(_controller.googleSignIn.currentUser.id.toString() + DateTime.now().millisecondsSinceEpoch.toString()).putFile(_image);//sem pasta
                    //FirebaseStorage.instance.ref().child("photos").child(_controller.googleSignIn.currentUser.id.toString() + DateTime.now().millisecondsSinceEpoch.toString()).putFile(_image);//com pasta
                    String url = await (await uploadTask).ref.getDownloadURL();
                    _controller.sendMessage(imgUrl: url);

                  },
                ),
              ),
              Expanded(
                  child: TextField(
                controller: _textController,
                decoration:
                    InputDecoration.collapsed(hintText: "Enviar mensagem..."),
                onChanged: (value) {
                  setState(() {
                    _isComposing = value.length > 0;
                  });
                },
                onSubmitted: (value) {
                  _controller.handleSubmitted(text: value);
                  _reset();
                },
              )),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Theme.of(context).platform == TargetPlatform.iOS
                    ? CupertinoButton(
                        child: Text("Enviar"),
                        onPressed: _isComposing
                            ? () {
                                _controller.handleSubmitted(
                                    text: _textController.text);
                                _reset();
                              }
                            : null)
                    : IconButton(
                        icon: Icon(Icons.send),
                        onPressed: _isComposing
                            ? () {
                                _controller.handleSubmitted(
                                    text: _textController.text);
                                _reset();
                              }
                            : null),
              ),
            ],
          ),
        ));
  }
}
