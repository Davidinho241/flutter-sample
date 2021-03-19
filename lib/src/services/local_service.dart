import 'dart:convert';
import 'package:coinpay/src/components/slidersComponent.dart';
import 'package:flutter/services.dart';

class LocalService {

  static Future<List<SliderComponent>> getSliders() async{
    var result = await rootBundle.loadString('assets/json/data/onboarding.json');
    var data = (json.decode(result) as List)
        .map<SliderComponent>((json) => SliderComponent.fromJson(json))
        .toList();
    return data;
  }
}
