import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:web_groupchat/core/services/firestore_service.dart';

import '../model/chat_model.dart';

class GroupRepo {
  final _fstore = FirestoreService();

  Future<List<GroupChatModel>?> getUserGroups(String user) async {
    List<GroupChatModel> groupChats = [];
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _fstore.groupCollection.where("members", whereIn: [user]).get();
    groupChats = snapshot.docs.map((e) {
      GroupChatModel group = GroupChatModel.fromJson(e.data());
      return group;
    }).toList();
    return groupChats;
  }

  Future<void> createGroup(GroupChatModel group, String id) async {
    await _fstore.groupCollection.doc(id).set(group.toJson());
  }

  Stream<List<GroupChatModel>>? groupStream;

  Future<List<GroupChatModel>?> streamGroup(String user) async {
    print("Stream open");
    groupStream = _fstore.groupCollection
        .where("members", arrayContains: user)
        // .orderBy("sendTime")
        .snapshots()
        .map((event) {
      print("Events from stream: ${event.docs.first}");
      if (event.docs.isNotEmpty) {
        return event.docs.map((e) {
          GroupChatModel _chat = GroupChatModel.fromJson(e.data());
          print("Members: ${_chat.members}");
          // _log.i(_chat.sender);
          return _chat;
        }).toList();
      } else {
        return [];
      }
    });
  }
}
