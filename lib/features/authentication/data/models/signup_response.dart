class SignUpResponse {
  int? id;
  String? email;
  String? firstName;
  String? lastName;
  String? address;
  String? firebaseConsoleManagerToken;
  String? password;
  String? dateJoined;

  SignUpResponse(
      {this.id,
        this.email,
        this.firstName,
        this.lastName,
        this.address,
        this.firebaseConsoleManagerToken,
        this.password,
        this.dateJoined});

  SignUpResponse.fromJson(Map<String, dynamic> json) {
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
