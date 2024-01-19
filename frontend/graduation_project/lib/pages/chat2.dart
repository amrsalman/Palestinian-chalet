import 'package:flutter/material.dart';

// Chat message model
class Message {
  final String text;
  final bool isSentByMe;

  Message({required this.text, required this.isSentByMe});
}

// Chat Interface Page
class ChatInterfacePage extends StatefulWidget {
  final String userName;

  ChatInterfacePage({Key? key, required this.userName}) : super(key: key);

  @override
  _ChatInterfacePageState createState() => _ChatInterfacePageState();
}

class _ChatInterfacePageState extends State<ChatInterfacePage> {
  final TextEditingController messageController = TextEditingController();
  List<Message> messages = []; // Holds the chat messages

  void sendMessage(String text) {
    if (text.trim().isEmpty) return;
    setState(() {
      messages.add(Message(text: text, isSentByMe: true));
      messageController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[50], // Light purple background for the whole page
      appBar: AppBar(
        backgroundColor: Colors.redAccent, // Purple AppBar to match the design
        title: Text(widget.userName),
        centerTitle: true,
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.phone),
        //     onPressed: () {},
        //   ),
        //   IconButton(
        //     icon: Icon(Icons.videocam),
        //     onPressed: () {},
        //   ),
        //   IconButton(
        //     icon: Icon(Icons.more_vert),
        //     onPressed: () {},
        //   ),
        // ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(10),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return Align(
                  alignment: message.isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
child: Container(
padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
decoration: BoxDecoration(
color: message.isSentByMe ? Colors.redAccent : Colors.grey[200],
borderRadius: BorderRadius.circular(20),
),
child: Text(
message.text,
style: TextStyle(
color: message.isSentByMe ? Colors.white : Colors.black87,
),
),
),
);
},
),
),
Container(
padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
decoration: BoxDecoration(
color: Colors.white,
boxShadow: [
BoxShadow(
color: Colors.grey.withOpacity(0.5),
spreadRadius: 2,
blurRadius: 5,
offset: Offset(0, -1.25), // changes position of shadow
),
],
),
child: Row(
children: [
IconButton(
icon: Icon(Icons.emoji_emotions_outlined, color: Colors.grey[600]),
onPressed: () {
// Handle emoji button press
},
),
Expanded(
child: TextField(
controller: messageController,
decoration

: InputDecoration(
hintText: "Type a message...",
hintStyle: TextStyle(color: Colors.grey[600]),
border: InputBorder.none,
),
),
),
IconButton(
icon: Icon(Icons.attach_file, color: Colors.grey[600]),
onPressed: () {
// Handle attach file button press
},
),
IconButton(
icon: Icon(Icons.send, color: Colors.redAccent),
onPressed: () {
sendMessage(messageController.text);
},
),
],
),
),
],
),
);
}
}