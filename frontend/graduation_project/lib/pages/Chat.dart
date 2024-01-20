import 'package:flutter/material.dart';
import 'package:graduation_project/pages/chat2.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class User {
  final String userName;

  User(this.userName);
}

class UsersListPage extends StatefulWidget {
  UsersListPage({Key? key}) : super(key: key);

  @override
  _UsersListPageState createState() => _UsersListPageState();
}

class _UsersListPageState extends State<UsersListPage> {
  final TextEditingController _searchController = TextEditingController();
  List<User> users = [];
  List<User> filteredUsers = [];

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    final prefs = await SharedPreferences.getInstance();

   // Retrieve the token from shared preferences
   final String? token = prefs.getString('token');
   print('token: ${token}');
   final String? username = prefs.getString('username');
   if (token == null || username == null) {
     // Handle the case where the token is not available
     // You might want to redirect the user to the login screen
     return;
    }
    final response = await http.get(Uri.parse('http://10.0.2.2:8080/api/v1/user'));
    
    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON
      List<dynamic> data = jsonDecode(response.body);
      List<User> fetchedUsers = data.map((user) => User(user['username'])).toList();
      // Remove the current user from the list
      fetchedUsers.removeWhere((user) => user.userName == username);
      setState(() {
        users = fetchedUsers;
        filteredUsers = fetchedUsers;
      });
    } else {
      // If the server did not return a 200 OK response,
      // throw an exception.
      throw Exception('Failed to load users');
    }
  }

  void _filterUsers(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredUsers = users;
      });
    } else {
      List<User> tmpList = [];
      for (User user in users) {
        if (user.userName.toLowerCase().contains(query.toLowerCase())) {
          tmpList.add(user);
        }
      }
      setState(() {
        filteredUsers = tmpList;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Users', style: TextStyle(color: Colors.redAccent)),
      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
      //   centerTitle: true,
      // ),
      body: Column(
        children: [
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                style: TextStyle(
                  color: Colors.white, // Text color
                ),
                decoration: InputDecoration(
                  hintText: 'Search for a user ',
                  hintStyle:
                      TextStyle(color: Colors.white54), // Hint text color
                  filled: true,
                  fillColor:
                      Colors.redAccent, // Background color of the search bar
                  prefixIcon:
                      Icon(Icons.search, color: Colors.white54), // Icon color
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none, // No border
                  ),
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 15.0), // Padding inside the search bar
                ),
                onChanged: _filterUsers,
              )),
          Expanded(
            child: ListView.builder(
              itemCount: filteredUsers.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(Icons.person),
                  title: Text(filteredUsers[index].userName),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChatInterfacePage(
                              userName: filteredUsers[index].userName)),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
