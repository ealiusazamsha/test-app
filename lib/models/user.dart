class User {
  final String id;
  final String username;
  final String email;
  final String? firstName;
  final String? lastName;
  final List<String> roles;

  User({
    required this.id,
    required this.username,
    required this.email,
    this.firstName,
    this.lastName,
    this.roles = const [],
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['sub'] ?? json['id'] ?? '',
      username: json['preferred_username'] ?? json['username'] ?? '',
      email: json['email'] ?? '',
      firstName: json['given_name'] ?? json['firstName'],
      lastName: json['family_name'] ?? json['lastName'],
      roles: (json['roles'] as List<dynamic>?)?.cast<String>() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'roles': roles,
    };
  }

  String get fullName {
    if (firstName != null && lastName != null) {
      return '$firstName $lastName';
    }
    return username;
  }
}
