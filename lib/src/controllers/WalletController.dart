import 'dart:convert';
import 'package:coinpay/src/services/prefs_service.dart';

import '../models/Wallet.dart';
import 'Controller.dart';
import 'package:http/http.dart' as http;
import 'package:coinpay/src/models/Wallet.dart';

class WalletController extends Controller{

  Future<Map<String, dynamic>> run(String route, Map<String, dynamic> data) async {
    final http.Response response = await Controller().makeRequest(route, data, null);
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return jsonData;
    } else {
      print(response.body);
      throw Exception('Failed to load Wallet');
    }
  }

  Future<List<Wallet>> getWallets(String route) async {
    try{
      final sharedPrefService = await SharedPreferencesService.instance;
      var token = sharedPrefService.token;
      final http.Response response = await Controller().fetchRequest(route , token);
      if (response.statusCode == 200) {
        print(response.body);

        // print(response.body);
        var jsonData = jsonDecode(response.body);
        List<Wallet> data = [];
        jsonData["data"].forEach((index, value) => data.add(Wallet.fromJson(value)));
        return data;
      } else {
        print(response.body);
        return null;
      }
    }catch(exception){
      print(exception);
      return null;
    }
  }

}