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

  String get username => fullName;

  Map<String, dynamic> toMap() => {
        'id': id,
        'username': fullName,
        'email': email,
        'phone': phone,
        'address': address,
        'bio': bio,
        'avatar_url': avatarUrl,
        'profile_picture_path': profilePicturePath,
        'member_since': memberSince.toIso8601String(),
      };

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

  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
        id: map['id']?.toString() ?? '',
        fullName: (map['username'] ??
                map['fullName'] ??
                map['nama'] ??
                map['name'])
            ?.toString() ??
            '',
        email: map['email']?.toString() ?? '',
        phone: (map['phone'] ?? map['no_telepon'] ?? map['telepon'])
                ?.toString() ??
            '',
        address: (map['address'] ?? map['alamat'])?.toString() ?? '',
        bio: map['bio']?.toString() ?? '',
        avatarUrl:
            (map['avatar_url'] ?? map['avatarUrl'])?.toString() ?? '',
        profilePicturePath: (map['profile_picture_path'] ??
                map['profilePicturePath'] ??
                map['foto_profil_path'])
            ?.toString(),
        memberSince: map['member_since'] != null
            ? DateTime.tryParse(map['member_since'].toString()) ??
                DateTime.now()
            : (map['memberSince'] != null
                ? DateTime.tryParse(map['memberSince'].toString()) ??
                    DateTime.now()
                : DateTime.now()),
      );

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      UserModel.fromMap(json);

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
