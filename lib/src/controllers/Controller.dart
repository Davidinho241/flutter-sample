import 'dart:convert';
import 'dart:io';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:http/http.dart' as http;

class Controller extends ControllerMVC{

  static final String mediaType = 'application/json; charset=UTF-8';

  Future<http.Response> makeRequest(String route, Map<String, dynamic> data, String token) async{
    print('route: ' +route);
    print('data: ' +data.toString());
    return await http.post(
      route,
      headers: <String, String>{
        'Content-Type': mediaType,
        HttpHeaders.authorizationHeader: token
      },
      body: jsonEncode(data),
    );
  }

  Future<http.Response> fetchRequest(String route, String token) async {
    print('route: ' +route);
    print('token: ' +token);
    return http.get(
      Uri.parse(route),
      // Send authorization headers to the backend.
      headers: {HttpHeaders.authorizationHeader: token},
    );
  }

}