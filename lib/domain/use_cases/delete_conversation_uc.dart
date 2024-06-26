import 'package:chatott/domain/repositories/conversation_repository.dart';

class DeleteConversationUseCase {
  final ConversationRepository repository;

  DeleteConversationUseCase({required this.repository});

  Future<void> call(String conversationId) async {
    try {
      return await repository.deleteConversation(
        conversationId: conversationId,
      );
    } catch (e) {
      rethrow;
    }
  }
}
