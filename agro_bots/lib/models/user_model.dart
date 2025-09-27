class UserModel {
  final String? id;
  final String fullName;
  final String email;
  final String? profileImage;

  UserModel({
    this.id,
    required this.fullName,
    required this.email,
    this.profileImage,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'profileImage': profileImage,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      profileImage: json['profileImage'],
    );
  }

  UserModel copyWith({
    String? id,
    String? fullName,
    String? email,
    String? profileImage,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      profileImage: profileImage ?? this.profileImage,
    );
  }
}
