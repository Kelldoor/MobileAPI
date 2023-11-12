import 'package:flutter/material.dart';
import 'package:petersweek12/Models/User.dart';
import 'package:petersweek12/Repositories/UserClient.dart';

class CreateUserPage extends StatefulWidget {
  @override
  _CreateUserPageState createState() => _CreateUserPageState();
}

class _CreateUserPageState extends State<CreateUserPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _authLevelController = TextEditingController();

  void _createUser() async {
    try {
      String username = _usernameController.text;
      String password = _passwordController.text;
      String email = _emailController.text;
      String authLevel = _authLevelController.text;

      print(
          'Creating user with username: $username, password: $password, email: $email, authLevel: $authLevel');

      UserClient userClient = UserClient();
      bool success =
          await userClient.createUser(username, password, email, authLevel);

      if (success) {
        print('User creation successful');
        Navigator.pop(context);
      } else {
        print('User creation failed');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Creation Successful.")),
        );
      }
    } catch (error) {
      print('Error creating user: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred while creating the user..")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create User'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _authLevelController,
              decoration: InputDecoration(labelText: 'Auth Level'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _createUser,
              child: Text('Create User'),
            ),
          ],
        ),
      ),
    );
  }
}
