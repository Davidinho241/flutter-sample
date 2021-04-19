import 'dart:convert';

import 'DefaultResponseAdapter.dart';

class DefaultResponse<T> {

  bool _status;
  int _message;
  String _token;
  T _model;
  bool _hasNext = false;
  List<T> _modelList;

  DefaultResponse();

  List<T> get getModelList => _modelList;

  bool get getHasNext => _hasNext;

  T get getModel => _model;

  String get getToken => _token;

  int get getMessage => _message;

  bool get getStatus => _status;

  bool isStatus(){
    return _status;
  }

  set setModel(T value) {
    _model = value;
  }

  void addModelToList(T model) {
    if (_modelList == null) {
      _modelList = [];
    }
    _modelList.add(model);
  }

  void parseFromJson(String response, DefaultResponseAdapter defaultResponseAdapter) async{
    var jsonObject = jsonDecode(response);
    print("server response : " +jsonObject.toString(5));
    int items = jsonObject.length();
    switch (items) {
      case 2:
      toDefault(jsonObject);
      break;
      case 3:
      toDefault(jsonObject);
      if (this.isStatus()) {
        defaultResponseAdapter.toDefaultWithModel(jsonObject, this);
      } else {
        parseFromSimpleJson(response);
      }
      break;
      case 4:
      toDefault(jsonObject);
      defaultResponseAdapter.toDefaultWithModel(jsonObject, this);
      this._token = jsonObject.getString("token");
      break;
      default:
      throw new Exception("Wrong response format " + jsonObject.toString(6));
    }

  }

  void parseFromSimpleJson(String response) async {
    print("server response : "+response);

    var jsonObject = jsonDecode(response);
    int items = jsonObject.length();

    switch (items) {
      case 2:
      toDefault(jsonObject);
      break;
      case 3:
      this._token = jsonObject["token"];
      //Config.setToken(this._token);
      break;
      default:
      throw new Exception("Wrong response format " + jsonObject.toString(6));
    }
  }

  void toDefault(Map<String, dynamic> jsonObject) async {
    this._status = jsonObject["status"];
    this._message = jsonObject["message"];
  }

}