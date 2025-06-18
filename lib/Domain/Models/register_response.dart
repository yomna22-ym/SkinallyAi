class RegisterResponse {
  final bool success;
  final String? message;
  final String? token;
  final String? refreshToken;
  final Map<String, dynamic>? user;

  RegisterResponse({
    required this.success,
    this.message,
    this.token,
    this.refreshToken,
    this.user,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      success: true,
      message: null,
      token: json['token'],
      refreshToken: json['refreshToken'],
      user: {
        'userId': json['userId'],
        'username': json['username'],
        'email': json['email'],
        'role': json['role'],
      },
    );
  }
}