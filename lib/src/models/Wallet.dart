class Wallet {
  String id;
  String userId;
  String name;
  String cryptoCurrency;
  String human;
  String description;
  double balance;
  bool isActivated;

  Wallet(this.id, this.userId, this.name, this.cryptoCurrency, this.human,
      this.description, this.balance, {this.isActivated = false});

  Wallet.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    name = json['name'];
    cryptoCurrency = json['cryptoCurrency'];
    human = json['human'];
    description = json['description'];
    balance = 2.0;
    isActivated = false;
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "userId": userId,
    "name": name,
    "cryptoCurrency": cryptoCurrency,
    "human": human,
    "description": description,
    "balance": balance,
    "isActivated": isActivated
  };

  String toString() => "{"
    +"id :"+id+", "
    +"userId :"+userId+", "
    +"name :"+name+", "
    +"cryptoCurrency :"+cryptoCurrency+", "
    +"human :"+human+", "
    +"description :"+description+", "
    +"isActivated :"+isActivated.toString()+", "
    +"balance : $balance"
    +"}"
  ;
}
