import 'dart:convert';
import 'package:coinpay/src/services/prefs_service.dart';

import 'Controller.dart';
import 'package:http/http.dart' as http;
import 'package:coinpay/src/models/User.dart';

class UserController extends Controller{

  Future<Map<String, dynamic>> run(String route, Map<String, dynamic> data) async {
    final http.Response response = await Controller().makeRequest(route, data);
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return jsonData;
    } else {
      print(response.body);
      throw Exception('Failed to load user');
    }
  }

  Future<String> register(String route, Map<String, dynamic> data) async {
    try{
      var response = await run(route, data);
      switch(response['code']){
        case 1000 :
          break;
        case 1001 :
          break;
        case 1002 :
          break;
        case 1003 :
          break;
        case 1004 :
          break;
        case 1006 :
          break;
        case 1007 :
          break;
      }
    }catch(exception){
      return exception.toString();
    }
  }

  Future<Map<String, dynamic>> login(String route, Map<String, dynamic> data) async{
    final http.Response response = await Controller().makeRequest(route, data);
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return jsonData;
    } else {
      print(response.body);
      throw Exception('Failed to load user');
    }
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
    final sharedPrefService = await SharedPreferencesService.instance;
    User user = new User();

    try{
      var response = await run(route, data);

      switch(response['code']){
        case 1000 :
          user = User.fromJson(response['data']);
          sharedPrefService.setToken(response['token']);
          return {
            'code':1000,
            'user': user
          };
          break;
        case 1001 :
          return {
            'code':1001,
            'error': "query error"
          };
          break;
        case 1002 :
          return {
            'code':1002,
            'error': "validation error"
          };
          break;
        default:
          return {
            'code':1001,
            'error': "Oops an Error !!!"
          };
          break;
      }
    }catch(exception){
      print(exception.toString());
      return {
        'code':1001,
        'error': "Oops an Error !!!",
        'type': exception.runtimeType
      };
    }
  }

}