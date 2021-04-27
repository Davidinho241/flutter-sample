import 'package:flutter/material.dart';
import 'package:coinpay/src/models/Wallet.dart';

class WalletProvider with ChangeNotifier{

  List<Wallet> _wallets = [];

  List<Wallet> get wallets{
    return [..._wallets];
  }

  WalletProvider(this._wallets);

  void checkWallet(Wallet wallet){
    notifyListeners();
  }
}