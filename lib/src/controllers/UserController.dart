import 'dart:convert';
import 'package:coinpay/src/services/prefs_service.dart';

import 'Controller.dart';
import 'package:http/http.dart' as http;
import 'package:coinpay/src/models/User.dart';

class UserController extends Controller{

  Future<Map<String, dynamic>> run(String route, Map<String, dynamic> data) async {
    final http.Response response = await Controller().makeRequest(route, data, null);
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return jsonData;
    } else {
      print(response.body);
      throw Exception('Failed to load user');
    }
  }

  Future<Map<String, dynamic>> logout(String route) async {
    final sharedPrefService = await SharedPreferencesService.instance;
    var token = sharedPrefService.token;
    final http.Response response = await Controller().fetchRequest(route , token);
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return jsonData;
    } else {
      print(response.body);
      throw Exception('Failed to load user');
    }
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
          print(response['message']);
          return {
            'code':1001,
            'error': "query error",
            'message': response['message']
          };
          break;
        case 1002 :
          print(response['message']);
          return {
            'code':1002,
            'error': "validation error"
          };
          break;
        default:
          print(response['message']);
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