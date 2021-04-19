import 'package:coinpay/src/models/Transaction.dart';
import 'package:coinpay/src/services/local_service.dart';
import 'package:coinpay/src/utils/sizes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:coinpay/src/widgets/cards.dart';

class MarketUI extends StatefulWidget {
  @override
  _MarketUIState createState() => _MarketUIState();
}

class _MarketUIState extends State<MarketUI> {
  List<Transaction> histories = []; // history data
  bool _loaded = false; // is loaded

  @override
  void initState() {
    super.initState();
    LocalService.loadTransactionHistory().then((value) {
      setState(() {
        _loaded = true;
        histories = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.maxFinite,
      width: double.maxFinite,
      child: _loaded
          ? ListView.builder(
        padding: EdgeInsets.all(Sizes.s15),
        itemCount: histories.length,
        itemBuilder: (context, index) {
          return TransactionHistoryCard(transaction: histories[index]);
        },
      )
          : Center(
        child: CupertinoActivityIndicator(),
      ),
    );
  }
}
