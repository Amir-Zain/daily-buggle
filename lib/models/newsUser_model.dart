class NewsUser {
  final String? name;
  final String? email;
  final String? profileImage;
  bool? isAdmin;

  NewsUser({this.name, this.email, this.profileImage, this.isAdmin});

  factory NewsUser.fromJson(json) {
    return NewsUser(
      name: json['name'],
      email: json['email'],
      profileImage: json['profileImage'],
      isAdmin: json['isAdmin'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "email": email,
      "profileImage": profileImage,
      "isAdmin": isAdmin,
    };
  }
}
