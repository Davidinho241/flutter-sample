import 'dart:convert';
import 'dart:io';
import 'package:coinpay/src/exceptions/AppException.dart';
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

  dynamic _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 1000:
        var responseJson = jsonDecode(response.body);
        print(responseJson);
        return responseJson;
      case 1001:
      case 1002:
      case 1003:
      case 1004:
      case 1005:
      case 1002:
        throw BadRequestException(response.body);
      case 401:
      case 403:
        throw UnauthorisedException(response.body);
      case 500:
      default:
        throw FetchDataException(
            'Error went communicating with Server, StatusCode : ${response
                .statusCode}');
    }
  }

}