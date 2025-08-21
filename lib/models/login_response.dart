import 'dart:convert';

LoginResponse loginResponseFromJson(String str) =>
    LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) =>
    json.encode(data.toJson());

class LoginResponse {
  final String status;
  final LoginData data;

  LoginResponse({
    required this.status,
    required this.data,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
    status: json['status'] as String,
    data: LoginData.fromJson(json['data'] as Map<String, dynamic>),
  );

  Map<String, dynamic> toJson() => {
    'status': status,
    'data': data.toJson(),
  };
}

class LoginData {
  final String accessToken;

  LoginData({required this.accessToken});

  factory LoginData.fromJson(Map<String, dynamic> json) => LoginData(
    accessToken: json['access_token'] as String,
  );

  Map<String, dynamic> toJson() => {
    'access_token': accessToken,
  };
}
