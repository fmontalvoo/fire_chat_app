class User {
  String id;
  String bio;
  String userName;
  String photoUrl;
  bool isOnline;
  String lastTime;

  User({
    this.id,
    this.bio,
    this.userName,
    this.photoUrl,
    this.isOnline,
    this.lastTime,
  });

  User.fromJson(Map<String, dynamic> json) {
    this.bio = json['bio'] ?? "";
    this.userName = json['userName'] ?? "";
    this.photoUrl = json['photoUrl'] ?? "";
    this.isOnline = json['isOnline'] ?? false;
    this.lastTime = json['lastTime'] ?? "";
  }

  Map<String, dynamic> toJson() {
    return {
      'id': this.id ?? "",
      'bio': this.bio ?? "",
      'userName': this.userName ?? "",
      'photoUrl': this.photoUrl ?? "",
      'isOnline': this.isOnline ?? true,
      'lastTime': this.lastTime ?? ""
    };
  }
}
