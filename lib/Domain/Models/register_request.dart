class RegisterRequest {
  final String username;
  final String email;
  final String password;
  final String phoneNumber;
  final String address;

  RegisterRequest({
    required this.username,
    required this.email,
    required this.password,
    required this.phoneNumber,
    required this.address,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'password': password,
      'phoneNumber': phoneNumber,
      'address': address,
    };
  }
}
