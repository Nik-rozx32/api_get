import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'modal/user.dart';
import 'dart:convert';

class UserData extends StatefulWidget {
  const UserData({Key? key}) : super(key: key);

  @override
  State<UserData> createState() => _UserDataState();
}

class _UserDataState extends State<UserData> {
  List<User> users = [];
  bool isLoading = true;

  Future<void> fetchUsers() async {
    final response =
        await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));

    if (response.statusCode == 200) {
      List jsonData = json.decode(response.body);
      List<User> loadedUsers =
          jsonData.map((item) => User.fromJson(item)).toList();
      setState(() {
        users = loadedUsers;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to load users');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Data'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return ListTile(
                  leading: Text('${user.id}'),
                  title: Text('${user.title}'),
                );
              },
            ),
    );
  }
}
