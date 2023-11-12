import 'package:flutter/material.dart';
import 'package:petersweek12/Models/User.dart';
import 'Models/AuthResponse.dart';
import 'Models/LoginStructure.dart';
import 'Repositories/UserClient.dart';
import 'Views/UsersView.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final UserClient userClient = UserClient();
  MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

bool _loading = false;

class _MyHomePageState extends State<MyHomePage> {
  String apiVersion = "";
  var usernameController = new TextEditingController();
  var passwordController = new TextEditingController();

  void initState() {
    super.initState();
    _loading = true;

    widget.userClient
        .GetApiVersion()
        .then((response) => {print(response), setApiVersion(response)});
  }

  void onLoginButtonPress() {
    setState(() {
      _loading = true;
      LoginStructure user =
          new LoginStructure(usernameController.text, passwordController.text);

      widget.userClient
          .Login(user)
          .then((response) => {onLoginCallCompleted(response)});
    });
  }

  void onLoginCallCompleted(var response) {
    if (response == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Login Failure.")));
    } else {
      getUsers();
    }

    setState(() {
      _loading = false;
    });
  }

  void getUsers() {
    setState(() {
      _loading = true;
      widget.userClient
          .GetUsersAsync()
          .then((response) => onGetUsersSuccess(response));
    });
  }

  onGetUsersSuccess(List<User>? users) {
    setState(() {
      if (users != null) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => UsersView(
                      inUsers: users,
                    )));
      }
    });
  }

  void setApiVersion(String version) {
    setState(() {
      apiVersion = version;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("Enter Credentials"),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextField(
                          controller: usernameController,
                          decoration: InputDecoration(hintText: "Username")),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                          controller: passwordController,
                          decoration: InputDecoration(hintText: "Password")),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: onLoginButtonPress,
                      child: Text("Login"),
                    ),
                  ],
                ),
              ],
            ),
            _loading
                ? Column(
                    children: [
                      CircularProgressIndicator(),
                      Text("Loading..."),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [Text(apiVersion)],
                  ),
          ],
        ),
      ),
    );
  }
}


// _loading
//                ? Column(
//                   children: [
//                      CircularProgressIndicator(),
//                      Text("Loading..."),
//                    ],
//                 )
//               : Text(apiVersion),