class User {
  int id;
  String firstName;
  String lastName;
  String email;
  String phone;
  String password;
  String avatar;
  int cityId;
  int genderId;
  int roleId;

  User({this.id, this.firstName, this.lastName, this.email, this.phone,
      this.password, this.cityId, this.genderId, this.roleId, this.avatar});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['firstname'],
      lastName: json['lastname'],
      email: json['email'],
      phone: json['phone'],
      password: json['password'],
      cityId: json['city_id'],
      genderId: json['gender_id'],
      roleId: json['role_id'],
      avatar: json['avatar'],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "firstname": firstName,
    "lastname": lastName,
    "email": email,
    "phone": phone,
    "password": password,
    "city_id": cityId,
    "gender_id": genderId,
    "role_id": roleId,
    "avatar": avatar,
  };

  static List<User> fromJsonList(List list) {
    if (list == null) return null;
    return list.map((item) => User.fromJson(item)).toList();
  }
}
