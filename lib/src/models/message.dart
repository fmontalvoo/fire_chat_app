import 'package:fire_chat_app/src/repository/data_repository.dart';

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

  Message.fromJson(var snapshot) {
    this.content = snapshot.value['content'] ?? "";
    this.idFrom = snapshot.value['idFrom'] ?? "";
    this.idTo = snapshot.value['idTo'] ?? "";
    this.timestamp = snapshot.value['timestamp'] ?? "";
    this.type = snapshot.value['type'] ?? 0;
    this.seen = snapshot.value['seen'] ?? false;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': this.timestamp,
      'content': this.content ?? "",
      'idFrom': this.idFrom ?? "",
      'idTo': this.idTo ?? "",
      'timestamp': this.timestamp ?? "",
      'type': this.type ?? 0,
      'seen': this.seen ?? false
    };
  }

  void save(String groupChatId) {
    DataRepository.messageDB
        .child(groupChatId)
        .child(this.timestamp)
        .set(this.toJson());
  }

  update(String groupChatId) async {
    await DataRepository.messageDB
        .child(groupChatId)
        .child(this.id)
        .update({"seen": this.seen});
  }
}
