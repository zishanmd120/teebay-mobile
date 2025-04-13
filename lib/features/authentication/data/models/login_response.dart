class LoginResponse {
  String? message;
  User? user;

  LoginResponse({this.message, this.user});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class User {
  int? id;
  String? email;
  String? firstName;
  String? lastName;
  String? address;
  String? firebaseConsoleManagerToken;
  String? password;
  String? dateJoined;

  User(
      {this.id,
        this.email,
        this.firstName,
        this.lastName,
        this.address,
        this.firebaseConsoleManagerToken,
        this.password,
        this.dateJoined});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    address = json['address'];
    firebaseConsoleManagerToken = json['firebase_console_manager_token'];
    password = json['password'];
    dateJoined = json['date_joined'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['address'] = address;
    data['firebase_console_manager_token'] = firebaseConsoleManagerToken;
    data['password'] = password;
    data['date_joined'] = dateJoined;
    return data;
  }
}
