class UserModel {
  final String userId;
  final String name;
  final String token;

  UserModel({required this.userId, required this.name, required this.token});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'],
      name: json['name'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'userId': userId, 'name': name, 'token': token};
  }
}
