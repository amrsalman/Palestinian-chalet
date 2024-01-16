import 'package:flutter/material.dart';
import 'package:graduation_project/pages/chat2.dart';

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
  List<User> users = [
    User('AmerZagha'),
    User('AmrSalman'),
    User('mohammadZagha'),
    User('Zainab'),
  ];
  List<User> filteredUsers = [];

  @override
  void initState() {
    super.initState();
    filteredUsers = users;
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
