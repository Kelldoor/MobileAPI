import 'package:petersweek12/Models/AuthResponse.dart';
import 'package:dio/dio.dart';
import '../Models/LoginStructure.dart';
import '../Models/User.dart';
import './DataService.dart';

// before deletion..
const String BaseUrl = "http://192.168.1.104:1250/Auth";

class UserClient {
  final _dio = Dio(BaseOptions(baseUrl: BaseUrl));
  DataService _dataService = DataService();
  String? loggedInUserId;

  Future<AuthResponse?> Login(LoginStructure user) async {
    try {
      var response = await _dio.post("/login",
          data: {'username': user.username, 'password': user.password});

      var data = response.data['data'];

      var authResponse = AuthResponse(data['userId'], data['token']);

      if (authResponse.token != null) {
        await _dataService.AddItem("token", authResponse.token);

        loggedInUserId = authResponse.userId;
      }

      return authResponse;
    } catch (error) {
      return null;
    }
  }

  Future<String> GetApiVersion() async {
    var response = await _dio.get("/ApiVersion");
    return response.data;
  }

  Future<List<User>?> GetUsersAsync() async {
    try {
      var token = await _dataService.TryGetItem("token");
      if (await _dataService.TryGetItem("token") != null) {
        var response = await _dio.get("/GetUsers",
            options: Options(headers: {
              "Content-Type": "application/json",
              "Accept": "application/json",
              "Authorization": "Bearer $token"
            }));
        List<User> users = <User>[];
        if (response != null) {
          for (var user in response.data) {
            users.add(User(user["Username"], user["Password"], user["Email"],
                user["AuthLevel"]));
          }
          return users;
        }
      } else {
        return null;
      }
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future<bool> deleteUserById() async {
    try {
      var token = await _dataService.TryGetItem("token");
      if (token != null && loggedInUserId != null) {
        var response = await _dio.delete(
          "/DeleteUserById",
          options: Options(
            headers: {
              "Content-Type": "application/json",
              "Accept": "application/json",
              "Authorization": "Bearer $token",
            },
          ),
          data: {'id': loggedInUserId},
        );

        return response.data['success'];
      } else {
        return false;
      }
    } catch (error) {
      print(error);
      return false;
    }
  }

  Future<bool> createUser(
      String username, String password, String email, String authLevel) async {
    try {
      var token = await _dataService.TryGetItem("token");
      if (token != null) {
        var response = await _dio.post(
          "/AddUser",
          options: Options(
            headers: {
              "Content-Type": "application/json",
              "Accept": "application/json",
              "Authorization": "Bearer $token"
            },
          ),
          data: {
            'username': username,
            'password': password,
            'email': email,
            'authLevel': authLevel,
          },
        );

        return response.data['success'];
      } else {
        return false;
      }
    } catch (error) {
      print(error);
      return false;
    }
  }
}
