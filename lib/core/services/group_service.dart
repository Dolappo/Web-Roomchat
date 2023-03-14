import 'package:web_groupchat/core/repo/group_repo.dart';
import 'package:web_groupchat/core/services/user_service.dart';

import '../../app/app_setup.locator.dart';
import '../model/chat_model.dart';

class GroupService {
  final _gRepo = GroupRepo();
  final _user = locator<UserService>();
  List<GroupChatModel> _groups = [];

  String _groupName = "";

  set groupName(String gName) {
    _groupName = gName;
  }

  Stream<List<GroupChatModel>>? get groupStream => _gRepo.groupStream;

  List<GroupChatModel> get groups => _groups;

  // GroupService(){
  //   openGroupStream();
  // }

  void openGroupStream() async {
    print("Stream ${_user.user!.email!}");
    await _gRepo.streamGroup(_user.user!.email!);
  }

  void getGroups() async {
    _groups = (await _gRepo.getUserGroups(_user.user!.email!))!;
  }

  Future<void> createGroup(GroupChatModel group) async {
    group.id = groupId;
    group.admin = _user.user!.email!;
    await _gRepo.createGroup(group, groupId);
  }

  String get groupId {
    return _user.user!.email! + _groupName.split(" ").last.toLowerCase();
  }
}
