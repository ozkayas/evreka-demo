class User {
  String name;
  String password;

  User({required this.name, required this.password});

  factory User.fromJson(Map<String, dynamic> json) =>
      User(name: json['name'], password: json['password']);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['password'] = this.password;
    return data;
  }
}
