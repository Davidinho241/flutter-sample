class Wallet {
  String id;
  String userId;
  String name;
  String cryptoCurrency;
  String human;
  String description;
  double balance;

  Wallet(this.id, this.userId, this.name, this.cryptoCurrency, this.human,
      this.description, this.balance);

  Wallet.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    name = json['name'];
    cryptoCurrency = json['cryptoCurrency'];
    human = json['human'];
    description = json['description'];
    balance = json['balance'].toDouble();
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "userId": userId,
    "name": name,
    "cryptoCurrency": cryptoCurrency,
    "human": human,
    "description": description,
    "balance": balance,
  };

  String toString() => "{"
    +"id :"+id+", "
    +"userId :"+userId+", "
    +"name :"+name+", "
    +"cryptoCurrency :"+cryptoCurrency+", "
    +"human :"+human+", "
    +"description :"+description+", "
    +"balance : $balance"
    +"}"
  ;
}
