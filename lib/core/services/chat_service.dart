import 'package:web_groupchat/core/repo/chat_repo.dart';
import 'package:web_groupchat/core/repo/group_repo.dart';
import 'package:web_groupchat/core/services/group_service.dart';

import '../../app/app_setup.locator.dart';
import '../model/chat.dart';

class ChatService {
  final _group = locator<GroupService>();
  final _chat = ChatRepo();

  Stream<List<ChatModel>> openChatStream(String groupId){
    return _chat.streamGroup(groupId);
  }

  Future<void> sendChat(String groupId, ChatModel chat) async{
    await _chat.sendChat(chat, groupId);
  }


}