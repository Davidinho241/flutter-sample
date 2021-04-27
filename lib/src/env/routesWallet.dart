class RoutesWallet {
  static final String BASE_URL = 'https://portemonnaie.herokuapp.com/api/v1/';
  static final String WALLETS_INFO = 'wallet/info';
  static final String RATE_INFO = 'cryptocurrency/convert';

  String buildRoute(String route){
    return BASE_URL+route;
  }
}