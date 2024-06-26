import 'dart:convert';

import 'package:chatott/data/models/conversation_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';

class ConversationDataSourceImpl {
  static Client _http = Client();
  static List<ConversationModel> _storeListConversation = [];

  Future<List<ConversationModel>> getAllConversation(String userJWT) async {
    Response resp = await _http.get(
        Uri.parse(
            'http://${dotenv.env["SERVER_URL"]}/kientrucphanmem/user/get-all-conversation'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $userJWT',
        });
    if (resp.statusCode != 200) {
      throw Exception('Failed to get conversation');
    }

    final json = jsonDecode(resp.body);
    if (json['code'] == 400) {
      return [];
    }
    else if (json['code'] != 200) {
      throw Exception('Failed to get conversation');
    }

    Iterable listJson = json['data'];
    _storeListConversation = listJson
        .map((conversation) =>
            ConversationModel.fromJson(conversation['conversation']))
        .toList();
    print('success');
    return _storeListConversation;
  }

  Future<ConversationModel> createConversation(
      List<String> listUser, String conversationName) async {
    Response resp = await _http.post(
        Uri.parse('http://${dotenv.env["SERVER_URL"]}/kientrucphanmem/conversation/create'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "userIdList": listUser.join(","),
          "conversationName": conversationName
        }));
    if (resp.statusCode == 200) {
      final json = jsonDecode(resp.body);
      final conversationModel =
          ConversationModel.fromJson(Map.castFrom(json['data']));
      _storeListConversation.add(conversationModel);
      print('success');
      return conversationModel;
    }
    print("fail");
    throw Exception('Failed to create conversation');
  }

  Future<void> deleteConversation({
    required String conversationId,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    // fakeListConversation.removeWhere((element) => element.id == conversationId);
  }

  // String generateRandomString(int len) {
  //   var r = Random();
  //   return String.fromCharCodes(
  //       List.generate(len, (index) => r.nextInt(33) + 89));
  // }
}
