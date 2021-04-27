class ActionComponent{
  String icon;
  String title;

  ActionComponent(this.icon, this.title);

  ActionComponent.fromJson(Map<String, dynamic> json) {
    icon = json['icon'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() => {
    "icon": icon,
    "title": title
  };

  String toString() => "{"
      +"icon :"+icon+", "
      +"title :"+title+"\n"
      +"}"
  ;
}