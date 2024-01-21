import 'dart:developer';
import 'package:socket_io_client/socket_io_client.dart'as IO;
class AppProvider extends ChangeNotifier{
  IO.socket? socket;
  connectToServer(){
    String server="http://10.0.2.2:8080";
    _socket = IO.io("${server}/", <String, dynamic>{
      'transports': ['websocket'],
    });
    socket.on("connect",(_){
      socket.emit("login","ahmad")
    });
    socket.on("newMessage",(data){
      
    });
    socket.emit("newMessage",data);
    // socket.on("newMessage",(data){

    //})
    
  }
  }