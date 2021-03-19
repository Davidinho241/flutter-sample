import 'package:vnum/vnum.dart';

@VnumDefinition
class Auth extends Vnum<int> implements Required{

  static const Auth ACCOUNT_NOT_VERIFY = const Auth.define(1100);
  static const Auth WRONG_USERNAME = const Auth.define(1101);
  static const Auth WRONG_PASSWORD = const Auth.define(1102);
  static const Auth WRONG_CREDENTIALS = const Auth.define(1103);
  static const Auth ACCOUNT_VERIFIED = const Auth.define(1104);
  static const Auth NOT_EXISTS = const Auth.define(1105);

  /// Constructors
  const Auth.define(int fromValue) : super.define(fromValue);
  factory Auth(int code) => Vnum.fromValue(code, Auth);

  /// (optional) Add these constructors if serilization is supported
  dynamic toJson() => this.value;
  factory Auth.fromJson(dynamic json) => Auth(json);

  int toCode() => this.value;

  bool equals(int code) {
    return this.value == code;
  }

  String toString() {
    return this.toString();
  }

}

@VnumDefinition
class Token extends Vnum<int> implements Required{

  static const Token TOKEN_EXPIRED = const Token.define(1);
  static const Token BLACK_LISTED_TOKEN = const Token.define(2);
  static const Token INVALID_TOKEN = const Token.define(3);
  static const Token NO_TOKEN = const Token.define(4);
  static const Token USER_NOT_FOUND = const Token.define(5);

  /// Constructors
  const Token.define(int fromValue) : super.define(fromValue);
  factory Token(int code) => Vnum.fromValue(code, Token);

  /// (optional) Add these constructors if serilization is supported
  dynamic toJson() => this.value;
  factory Token.fromJson(dynamic json) => Token(json);

  int toCode() => this.value;

  bool equals(int code) {
    return this.value == code;
  }

  String toString() {
    return this.toString();
  }

}

@VnumDefinition
class Request extends Vnum<int> implements Required{

  static const Request SUCCESS = const Request.define(1000);
  static const Request FAILURE = const Request.define(1001);
  static const Request VALIDATION_ERROR = const Request.define(1002);
  static const Request EXPIRED = const Request.define(1003);
  static const Request TRYING_TO_INSERT_DUPLICATE = const Request.define(1004);
  static const Request NOT_AUTHORIZED = const Request.define(1005);
  static const Request EXCEPTION = const Request.define(1006);
  static const Request NOT_FOUND = const Request.define(1007);
  static const Request WRONG_JSON_FORMAT = const Request.define(1008);

  /// Constructors
  const Request.define(int fromValue) : super.define(fromValue);
  factory Request(int code) => Vnum.fromValue(code, Request);

  /// (optional) Add these constructors if serilization is supported
  dynamic toJson() => this.value;
  factory Request.fromJson(dynamic json) => Request(json);

  int toCode() => this.value;

  bool equals(int code) {
    return this.value == code;
  }

  String toString() {
    return this.toString();
  }

}

abstract class Required {
  int toCode();

  bool equals(int code);

  String toString();
}


class RequestCode {

   static Auth authMessage(int code) {
    for (Auth auth in Vnum.allCasesFor(Auth)) {
      if (auth.equals(code)) {
      return auth;
      }
    }
    return Auth.NOT_EXISTS;
  }

   static Token tokenMessage(int code) {
     for (Token token in Vnum.allCasesFor(Token)) {
       if (token.equals(code)) {
         return token;
       }
     }
     return Token.USER_NOT_FOUND;
   }

   static Request requestMessage(int code) {
     for (Request request in Vnum.allCasesFor(Request)) {
       if (request.equals(code)) {
         return request;
       }
     }
     return Request.NOT_FOUND;
   }
}