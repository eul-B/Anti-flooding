class User {
  String user_id;
  String user_name;
  String user_email;
  String user_password;

  User(
    this.user_id,
    this.user_name,
    this.user_email,
    this.user_password,
  );

  factory User.fromJson(Map<String, dynamic> json) => User(
        json['user_id'],
        json['user_name'],
        json['user_email'],
        json['user_assword'],
      );

  Map<String, dynamic> toJson() => {
        'user_id': user_id,
        'user_name': user_name,
        'user_email': user_email,
        'user_password': user_password,
      };
}
