import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rb_chat/providers/userProvider.dart';

class ChatroomScreen extends StatefulWidget {
  String chatroomName;
  String chatroomId;
  ChatroomScreen(
      {super.key, required this.chatroomName, required this.chatroomId});

  @override
  State<ChatroomScreen> createState() => _ChatroomScreenState();
}

class _ChatroomScreenState extends State<ChatroomScreen> {
  TextEditingController messageText = TextEditingController();

  var db = FirebaseFirestore.instance;
  Future<void> sendMessage() async {
    if (messageText.text.isEmpty) {
      SnackBar messageSnackBar = SnackBar(
        content: Text("Write some text to send."),
        backgroundColor: Colors.red,
      );

      ScaffoldMessenger.of(context).showSnackBar(messageSnackBar);
      return;
    }
    Map<String, dynamic> messageToSend = {
      "text": messageText.text,
      "sender_name": Provider.of<UserProvider>(context, listen: false).userName,
      "chatroom_id": widget.chatroomId,
      "timestamp": FieldValue.serverTimestamp(),
    };

    try {
      await db.collection("messages").add(messageToSend);

      messageText.text = "";
    } catch (e) {
      SnackBar messageSnackBar = SnackBar(
        content: Text("Message not sent. Try again."),
        backgroundColor: Colors.red,
      );

      ScaffoldMessenger.of(context).showSnackBar(messageSnackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chatroomName),
        centerTitle: true,
        backgroundColor: Colors.amberAccent,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: db
                  .collection("messages")
                  .orderBy("timestamp", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                var allMessages = snapshot.data?.docs ?? [];
                return ListView.builder(
                  reverse: true,
                  itemCount: allMessages.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text(allMessages[index]["text"]),
                        ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.blueGrey[900],
                            child: Text(
                              allMessages[index]["sender_name"][0],
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          title: Text(allMessages[index]["text"]),
                          subtitle: Text(allMessages[index]["sender_name"],
                              style: TextStyle(color: Colors.blueGrey[300])),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          Container(
            color: Colors.grey[300],
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageText,
                      decoration: InputDecoration(
                        hintText: "Write message here..",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  InkWell(
                    child: Icon(Icons.send),
                    onTap: () {
                      sendMessage();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
