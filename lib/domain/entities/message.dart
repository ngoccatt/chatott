import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class Message {
  final int id;
  final Sender sender;
  final String content;
  final String status;
  final int lastTime;

  const Message({
    required this.id,
    required this.sender,
    required this.content,
    required this.status, // read, unread
    required this.lastTime,
  });

  // compare with id object.
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Message && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  static const Message empty = Message(
    id: -1,
    sender: Sender(id: -1, lastName: '', firstName: '', avatar: ''),
    content: '',
    status: '',
    lastTime: 0,
  );

  // An entity can be an object with methods, or it can be a set of
  // data structures and functions.
  bool get isEmpty => this == Message.empty;

  List<Object?> get props => [
        id,
        sender.lastName,
        sender.firstName,
        sender.avatar,
        content,
        status,
        lastTime.toString(),
      ];

  types.TextMessage toTextMessage() {
    return types.TextMessage(
        author: sender.toChatTypeUser(),
        id: id.toString(),
        text: content,
        createdAt: lastTime);
  }

  static Message fromTextMessage(types.TextMessage message) {
    return Message(
      id: int.parse(message.id),
      sender: Sender(
        id: int.parse(message.author.id),
        lastName: message.author.lastName!,
        firstName: message.author.firstName!,
        avatar: message.author.imageUrl!,
      ),
      content: message.text,
      status: 'read',
      lastTime: message.createdAt!,
    );
  }
}

class Sender {
  final int id;
  final String? email;
  final String? phone;
  final String lastName;
  final String firstName;
  final String avatar;

  const Sender({
    required this.id,
    this.email,
    this.phone,
    required this.lastName,
    required this.firstName,
    required this.avatar,
  });

  types.User toChatTypeUser() {
    return types.User(
      id: id.toString(),
      firstName: firstName,
      lastName: lastName,
      imageUrl: avatar,
    );
  }
}
