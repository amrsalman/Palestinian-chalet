import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async'; // Add this import statement

class ChatInterfacePage extends StatefulWidget {
  final String userName;

  ChatInterfacePage({Key? key, required this.userName}) : super(key: key);

  @override
  _ChatInterfacePageState createState() => _ChatInterfacePageState();
}

class _ChatInterfacePageState extends State<ChatInterfacePage> {
  late WebSocketChannel _channel;
  final TextEditingController messageController = TextEditingController();
  List<String> messages = [];
  late SharedPreferences prefs;
  String? token;
  String? username;
  late StreamController<List<int>> _streamController;

  @override
  void initState() {
    super.initState();
    initializePreferences();
    _streamController = StreamController<List<int>>(); // Create a StreamController
  }

  Future<void> initializePreferences() async {
    prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    username = prefs.getString('username');

    if (token == null || username == null) {
      return;
    }
    _channel = IOWebSocketChannel.connect('ws://10.0.2.2:8081?sender=${username}&receiver=${widget.userName}');
    _channel.stream.listen((data) {
      _streamController.add(data); // Add data to the StreamController
    });
  }

  @override
  void dispose() {
    _channel.sink.close();
    _streamController.close(); // Close the StreamController
    super.dispose();
  }

  void sendMessage(String text) {
    if (text.trim().isEmpty || _channel == null) return;
    _channel.sink.add(text);
    setState(() {
      messages.add('Me: $text');
      messageController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[50],
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Text(widget.userName),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: _streamController.stream, // Subscribe to data coming from the server
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<int> numericList = snapshot.data as List<int>;
                  String message = String.fromCharCodes(numericList);
                  if (!messages.contains(message)) {
                    messages.add('$message'); // Add the new message
                  }
                }

                return ListView.builder(
                  padding: EdgeInsets.all(10),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return Align(
                      alignment: message.startsWith('Me') ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        decoration: BoxDecoration(
                          color: message.startsWith('Me') ? Colors.redAccent : Colors.grey[500],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          message,
                          style: TextStyle(
                            color: message.startsWith('Me') ? Colors.white : Colors.black87,
                          ),
                        ),
                      ),
                    );
                  },
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
                  offset: Offset(0, -1.25),
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
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      hintStyle: TextStyle(color: Colors.grey[600]),
                      border: InputBorder.none,
                    ),
                  ),
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
