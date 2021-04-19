class Wallet {
  String id;
  String userId;
  String name;

  Wallet({
    this.id,
    this.userId,
    this.name,
  });

  Wallet.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "userId": userId,
    "name": name,
  };

  String toString() => "{"
    +"id :"+id+", "
    +"userId :"+userId+", "
    +"name :"+name
    +"}"
  ;
}
