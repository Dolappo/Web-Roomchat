import 'package:web_groupchat/core/repo/group_repo.dart';
import 'package:web_groupchat/core/services/user_service.dart';

import '../../app/app_setup.locator.dart';
import '../model/chat_model.dart';

class GroupService {
  final _gRepo = GroupRepo();
  final _user = locator<UserService>();
  // List<GroupChatModel>? _groups;

  // GroupService() {
  //   getGroups();
  // }

  String _groupName = "";

  GroupChatModel? _selectedGroup;

  GroupChatModel? get selectedGroup => _selectedGroup;

  set selectGroup(GroupChatModel group) {
    _selectedGroup = group;
  }

  bool get isAdmin => _selectedGroup!.admin! == _user.user!.email!;

  set groupName(String gName) {
    _groupName = gName;
  }

  Stream<List<GroupChatModel>>? get groupStream => _gRepo.groupStream;

  // List<GroupChatModel>? get publicGroups => _groups;

  // GroupService(){
  //   openGroupStream();
  // }

  void openGroupStream() async {
    print("Stream ${_user.user!.email!}");
    await _gRepo.streamGroup(_user.user!.email!);
  }

  Future<List<GroupChatModel>?> getGroups() async {
    return await _gRepo.getPublicGroups(_user.user!.email!);
    // print("Get groups ${_groups?.first.name}");
  }

  Future<void> createGroup(GroupChatModel group) async {
    group.id = groupId;
    group.admin = _user.user!.email!;
    await _gRepo.createGroup(group, groupId);
  }

  Future<void> addUserToGroup(List<String> members, String id) async {
    _gRepo.addUserToGroup(members, id);
  }

  String get groupId {
    return _user.user!.email! + _groupName.split(" ").last.toLowerCase();
  }
}
