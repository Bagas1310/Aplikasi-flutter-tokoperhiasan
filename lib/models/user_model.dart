class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String address;
  final String bio;
  final String avatarUrl;
  final String? profilePicturePath;
  final DateTime memberSince;

  const UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    this.phone = '',
    this.address = '',
    this.bio = '',
    this.avatarUrl = '',
    this.profilePicturePath,
    required this.memberSince,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'fullName': fullName,
        'email': email,
        'phone': phone,
        'address': address,
        'bio': bio,
        'avatarUrl': avatarUrl,
        'profilePicturePath': profilePicturePath,
        'memberSince': memberSince.toIso8601String(),
      };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] as String,
        fullName: json['fullName'] as String,
        email: json['email'] as String,
        phone: json['phone'] as String? ?? '',
        address: json['address'] as String? ?? '',
        bio: json['bio'] as String? ?? '',
        avatarUrl: json['avatarUrl'] as String? ?? '',
        profilePicturePath: json['profilePicturePath'] as String?,
        memberSince: DateTime.parse(json['memberSince'] as String),
      );

  UserModel copyWith({
    String? id,
    String? fullName,
    String? email,
    String? phone,
    String? address,
    String? bio,
    String? avatarUrl,
    String? profilePicturePath,
    DateTime? memberSince,
  }) =>
      UserModel(
        id: id ?? this.id,
        fullName: fullName ?? this.fullName,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        address: address ?? this.address,
        bio: bio ?? this.bio,
        avatarUrl: avatarUrl ?? this.avatarUrl,
        profilePicturePath: profilePicturePath ?? this.profilePicturePath,
        memberSince: memberSince ?? this.memberSince,
      );
}
