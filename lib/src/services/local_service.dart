import 'dart:convert';
import 'package:coinpay/src/components/slidersComponent.dart';
import 'package:coinpay/src/components/walletsComponent.dart';
import 'package:coinpay/src/controllers/WalletController.dart';
import 'package:coinpay/src/env/routesWallet.dart';
import 'package:coinpay/src/models/Transaction.dart';
import 'package:coinpay/src/models/Wallet.dart';
import 'package:flutter/services.dart';

class LocalService {

  static Future<List<SliderComponent>> getSliders() async{
    var result = await rootBundle.loadString('assets/json/data/onboarding.json');
    var data = (json.decode(result) as List)
        .map<SliderComponent>((json) => SliderComponent.fromJson(json))
        .toList();
    return data;
  }

  static Future<List<WalletComponent>> getWallets() async{
    var result = await rootBundle.loadString('assets/json/data/wallet.json');
    var data = (json.decode(result) as List)
        .map<WalletComponent>((json) => WalletComponent.fromJson(json))
        .toList();
    return data;
  }

  static Future<List<Transaction>> loadTransactionHistory() async {
    await Future.delayed(Duration(milliseconds: 2000));
    var result = await rootBundle.loadString('assets/json/data/history.json');
    var data = (json.decode(result) as List)
        .map<Transaction>((json) => Transaction.fromJson(json))
        .toList();
    return data;
  }

  static Future<List<Wallet>> loadWallets() async {
    await Future.delayed(Duration(milliseconds: 15000));
    var result = await WalletController().getWallets(RoutesWallet().buildRoute(RoutesWallet.WALLETS_INFO));
    return result;
  }
}
