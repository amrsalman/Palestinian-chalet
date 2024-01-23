import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async'; // Add this import statement
import 'dart:convert';

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
  List<String> sendars = [];
  late SharedPreferences prefs;
  String? token;
  String? username;
  late StreamController<List<int>> _streamController;
  late ScrollController _scrollController; // Add ScrollController

  @override
  void initState() {
    super.initState();
    initializePreferences();
    _streamController = StreamController<List<int>>(); // Create a StreamController
    _scrollController = ScrollController(); // Initialize ScrollController
    
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
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
      // Parse the JSON string into a List<dynamic>
      List<dynamic> jsonData = json.decode(data);

      // Convert the List<dynamic> to List<Map<String, dynamic>>
      List<Map<String, dynamic>> messagesList = jsonData.cast<Map<String, dynamic>>();

      // Extract the content of each message
      List<String> receivedMessages = messagesList.map<String>((message) => message['content'] as String).toList();
      List<String> send = messagesList.map<String>((message) => message['sender'] as String).toList();
      // Handle received messages and update UI
      setState(() {
        messages = [];
        messages.addAll(receivedMessages);
        sendars = [];
        sendars.addAll(send);
        _scrollController.animateTo(
       _scrollController.position.maxScrollExtent,
       duration: Duration(milliseconds: 300),
       curve: Curves.easeOut,
      );
      });
      // Scroll to the bottom when new message is sent
      _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
     );
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
      messages.add('$text');
      messageController.clear();
      sendars.add('$username');
    });
    // Scroll to the bottom when new message is sent
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }
  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300), curve: Curves.elasticOut);
    } else {
      Timer(Duration(milliseconds: 400), () => _scrollToBottom());
    }
 }
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
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
                  //String message = snapshot.data;
                  if (!messages.contains(message)) {
                    messages.add('$message'); // Add the new message
                  }
                   // Split the received messages by a delimiter (e.g., '\n')
                   /*for (var message in numericList) {
                      messages.add(message["content"]);
                    }*/
                    ///List<String> receivedMessages = message.split('\n').where((msg) => msg.isNotEmpty).toList();

                    // Add the new messages to the messages list
                    //messages.addAll(receivedMessages.where((msg) => msg.isNotEmpty));
                }

                return ListView.builder(
                  controller: _scrollController, // Attach the ScrollController to the ListView
                  padding: EdgeInsets.all(10),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return Align(
                      alignment: sendars[index] == username ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        decoration: BoxDecoration(
                          color: sendars[index] == username ? Colors.redAccent : Colors.grey[500],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          message,
                          style: TextStyle(
                            color: sendars[index] == username ? Colors.white : Colors.black87,
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