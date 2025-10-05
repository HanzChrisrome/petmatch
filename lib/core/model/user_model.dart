class AppUser {
  final String id;
  final String fullName;
  final String email;
  final String role;

  AppUser({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['user_id'] as String,
      fullName: json['full_name'] as String? ?? '',
      email: json['user_email'] as String? ?? '',
      role: json['user_role'] as String? ?? 'user',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': id,
      'full_name': fullName,
      'user_email': email,
      'user_role': role,
    };
  }
}
