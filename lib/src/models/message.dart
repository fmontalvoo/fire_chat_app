class Message {
  String id;
  String content;
  String idFrom;
  String idTo;
  String timestamp;
  int type;
  bool seen;

  Message({
    this.id,
    this.content,
    this.idFrom,
    this.idTo,
    this.timestamp,
    this.type,
    this.seen,
  });

  Message.fromJson(Map<String, dynamic> json) {
    this.id = json['id'] ?? "";
    this.content = json['content'] ?? "";
    this.idFrom = json['idFrom'] ?? "";
    this.idTo = json['idTo'] ?? "";
    this.timestamp = json['timestamp'] ?? "";
    this.type = json['type'] ?? "";
    this.seen = json['seen'] ?? "";
  }

  Map<String, dynamic> toMap() {
    return {
      'content': this.content ?? "",
      'idFrom': this.idFrom ?? "",
      'idTo': this.idTo ?? "",
      'timestamp': this.timestamp ?? "",
      'type': this.type ?? 0,
      'seen': this.seen ?? false
    };
  }
}
