class Message {
  final String sender;
  final String recipient;
  final String content;

  Message({
    required this.sender,
    required this.recipient,
    required this.content,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      sender: json['sender'],
      recipient: json['recipient'],
      content: json['content'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sender': sender,
      'recipient': recipient,
      'content': content,
    };
  }
}
