import 'package:web_groupchat/core/repo/chat_repo.dart';
import '../model/chat.dart';

class ChatService {
  final _chat = ChatRepo();

  Stream<List<ChatModel>> openChatStream(String groupId) {
    return _chat.streamGroup(groupId);
  }

  Future<void> sendChat(String groupId, ChatModel chat) async {
    await _chat.sendChat(chat, groupId);
  }
}
