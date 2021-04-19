class WalletComponent {
  String icon;
  String inactivatedIcon;
  String title;
  String currency;

  WalletComponent(this.icon, this.title, this.inactivatedIcon, this.currency);

  WalletComponent.fromJson(Map<String, dynamic> json) {
    icon = json['icon'];
    title = json['title'];
    inactivatedIcon = json['inactivatedIcon'];
    currency = json['currency'];
  }

  Map<String, dynamic> toJson() => {
    "icon": icon,
    "title": title,
    "inactivatedIcon": inactivatedIcon,
    "currency": currency
  };

  String toString() => "{"
    +"icon :"+icon+", "
    +"title :"+title+", "
    +"inactivatedIcon :"+inactivatedIcon+", "
    +"currency :"+currency
    +"}"
  ;
}