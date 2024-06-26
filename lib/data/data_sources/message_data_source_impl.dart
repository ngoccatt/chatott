import 'dart:async';
import 'dart:convert';

import 'package:chatott/data/models/message_model.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MessageDataSourceImpl {
  static List<MessageModel> _storeListMessage = [];

  static late StompClient stompClient;
  static late StreamController<List<MessageModel>> streamController;

  Stream<List<MessageModel>> getConversationMessage(
      int userId, int conversationId) {
    void onConnect(StompFrame frame) {
      stompClient.subscribe(
        destination: '/topic/public2',
        callback: (StompFrame frame) {
          // receive message from server
          final data = jsonDecode(frame.body!);
          if (data is Map) {
            Map<String, dynamic> messageJson = jsonDecode(frame.body!);
            print("messageJson: $messageJson");
            if (messageJson['type'] == 'LEAVE') {
              return;
            }
            _storeListMessage.add(MessageModel.fromJson(messageJson));
            streamController.add(_storeListMessage.reversed.toList());
          } else if (data is List) {
            Iterable listJson = jsonDecode(frame.body!);
            _storeListMessage = listJson
                .map((message) => MessageModel.fromJson(message))
                .toList();
            print("messagesJson: $_storeListMessage");
            streamController.add(_storeListMessage.reversed.toList());
          }
        },
      );

      stompClient.send(
        destination: '/app/chat.register2',
        body: jsonEncode(<String, Object>{
          "msgFrom": userId,
          "type": "JOIN",
          "conversationId": conversationId,
        }),
      );
    }

    void connectSocket() {
      print("userId: $userId; conversationId: $conversationId");
      stompClient = StompClient(
          config: StompConfig.sockJS(
        url: 'http://${dotenv.env["SERVER_URL"]}/websocket',
        onConnect: onConnect,
        onStompError: (StompFrame frame) {
          print(
              'A stomp error occurred in web socket connection :: ${frame.body}');
        },
        onWebSocketError: (dynamic frame) {
          print(
              'A Web socket error occurred in web socket connection :: ${frame.toString()}');
        },

      ));

      if (!stompClient.connected) {
        stompClient.activate();
      }
    }

    void disconnectSocket() {
      if (stompClient.connected) {
        stompClient.deactivate();
      }
      _storeListMessage.clear();
    }

    streamController = StreamController<List<MessageModel>>(
      onListen: () => connectSocket(),
      onCancel: () => disconnectSocket(),
      onPause: () => print("Pause"),
      onResume: () => print("Resume"),
    );
    return streamController.stream;
  }

  Future<void> sendMessage(
      int userId, String content, int conversationId, String sessionId) async {
    stompClient.send(
      destination: '/app/chat.send2',
      body: jsonEncode(<String, Object>{
        'msgFrom': userId,
        'content': content,
        'type': 'CHAT',
        'conversationId': conversationId,
        'sessionId': sessionId,
      }),
    );
  }

  Future<void> deleteMessage(int messageId) async {
    _storeListMessage.removeWhere((element) => element.id == messageId);
  }
}
