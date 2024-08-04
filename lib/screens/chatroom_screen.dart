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
      "sender_id": Provider.of<UserProvider>(context, listen: false).userId,
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

  Widget singleChatMessage(
      {required String sender_name,
      required String text,
      required String sender_id}) {
    return Column(
      // crossAxisAlignment:
      //     sender_id == Provider.of<UserProvider>(context, listen: false).userId
      //         ? CrossAxisAlignment.end
      //         : CrossAxisAlignment.start,
      children: [
        sender_id == Provider.of<UserProvider>(context, listen: false).userId
            ? ListTile(
                trailing: CircleAvatar(
                  backgroundColor: Colors.blueGrey[900],
                  child: Text(
                    sender_name[0],
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(text, textAlign: TextAlign.right),
                subtitle: Text(
                  sender_name,
                  textAlign: TextAlign.right,
                  style: TextStyle(color: Colors.blueGrey[300]),
                ),
              )
            : ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blueGrey[900],
                  child: Text(
                    sender_name[0],
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(text),
                subtitle: Text(sender_name,
                    style: TextStyle(color: Colors.blueGrey[300])),
              ),
      ],
    );
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
                  .where("chatroom_id", isEqualTo: widget.chatroomId)
                  .orderBy("timestamp", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  print(snapshot.error);
                  return Center(child: Text("Some error has occured!"));
                }

                var allMessages = snapshot.data?.docs ?? [];

                if (allMessages.length < 1) {
                  return Center(child: Text("No message found!"));
                }

                return ListView.builder(
                  reverse: true,
                  itemCount: allMessages.length,
                  itemBuilder: (BuildContext context, int index) {
                    return singleChatMessage(
                        sender_id: allMessages[index]["sender_id"],
                        sender_name: allMessages[index]["sender_name"],
                        text: allMessages[index]["text"]);
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
