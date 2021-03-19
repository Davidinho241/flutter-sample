import 'dart:convert';
import 'Controller.dart';
import 'package:http/http.dart' as http;
import 'package:coinpay/src/models/User.dart';

class UserController extends Controller{

  Future<Map<String, dynamic>> register(String route, Map<String, dynamic> data) async {
    final http.Response response = await Controller().makeRequest(route, data);
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return jsonData;
    } else {
      print(response.body);
      throw Exception('Failed to load user');
    }
  }

  Future<User> login(){

  }

  Future<User> logout(){

  }

  Future<User> me(){

  }

  Future<User> forgotPassword(){

  }

  Future<User> ResetPassword(){

  }

  Future<Map<String, dynamic>> verifyOTP(String route, Map<String, dynamic> data) async{
    final http.Response response = await Controller().makeRequest(route, data);
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return jsonData;
    } else {
      print(response.body);
      throw Exception('Failed to load user');
    }
  }

}