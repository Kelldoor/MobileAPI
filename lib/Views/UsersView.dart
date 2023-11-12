import 'package:flutter/material.dart';
import 'package:petersweek12/Models/LoginStructure.dart';
import 'package:petersweek12/Models/User.dart';
import 'create_user.dart';
import 'package:petersweek12/Repositories/UserClient.dart';

class UsersView extends StatefulWidget {
  final List<User> inUsers;

  const UsersView({Key? key, required this.inUsers}) : super(key: key);

  @override
  State<UsersView> createState() => _UsersViewState(inUsers);
}

class _UsersViewState extends State<UsersView> {
  late List<User> users;
  late UserClient userClient;

  _UsersViewState(List<User> users) {
    this.users = users;
    this.userClient = UserClient();
  }

  void createUser() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreateUserPage()),
    );
  }

  Future<void> _showDeleteConfirmationDialog(User user) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Deletion"),
          content: Text("Are you sure you want to delete this user?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();

                var authResponse = await userClient.Login(
                  LoginStructure(user.Username, user.Password),
                );

                if (authResponse != null) {
                  bool success = await userClient.deleteUserById();
                  if (success) {
                    setState(() {
                      users.removeWhere((u) => u.Username == user.Username);
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Failed to delete user.")),
                    );
                  }
                }
              },
              child: Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("View Users"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: users.map((user) {
            return Padding(
              padding: EdgeInsets.all(3),
              child: Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.person),
                      title: Text("Username: ${user.Username}"),
                      subtitle: Text("Auth Level: ${user.AuthLevel}"),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        TextButton(
                          onPressed: () {},
                          child: Text("UPDATE"),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        TextButton(
                          onPressed: () {
                            _showDeleteConfirmationDialog(user);
                          },
                          child: const Text("DELETE"),
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createUser,
        child: Icon(Icons.add),
      ),
    );
  }
}
