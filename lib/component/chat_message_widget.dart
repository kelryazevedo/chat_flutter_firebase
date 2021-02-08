import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatMessageWidget extends StatelessWidget {
  final Map<String, dynamic> data;

  const ChatMessageWidget({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage(data["senderPhotoUrl"]),
            ),
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data["senderName"],
                style: Theme.of(context).textTheme.subtitle1,
              ),
              Container(
                margin: EdgeInsets.only(top: 5.0),
                child: data["imgUrl"] != null
                    ? Image.network(data["imgUrl"],width: 250.0,)
                    : Text(data["message"]),
              )
            ],
          ))
        ],
      ),
    );
  }
}
