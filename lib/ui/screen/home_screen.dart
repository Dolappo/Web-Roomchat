import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';
import 'package:web_groupchat/core/model/chat_model.dart';
import 'package:web_groupchat/ui/screen/home_view_model.dart';
import 'package:web_groupchat/ui/widgets/textfield.dart';
import 'package:web_groupchat/utils/extension.dart';

import '../../core/model/chat.dart';
import '../widgets/button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
        viewModelBuilder: () => HomeViewModel(),
        builder: (context, model, _) {
          return Scaffold(
            body: Row(
              children: [
                Visibility(
                  visible: !model.viewProfile,
                  replacement: Expanded(flex: 2, child: ProfileBox()),
                  child: Expanded(
                      flex: 2,
                      child: Container(
                        color: Colors.grey.shade100,
                        child: ChatList(),
                      )),
                ),
                Gap(5),
                Expanded(
                    flex: model.viewGroupDetails ? 2 : 5,
                    child: Container(
                      color: Colors.grey.shade100,
                      child: MessageStream(),
                    )),
                Visibility(
                    visible: model.viewGroupDetails,
                    replacement: SizedBox(),
                    child: Expanded(flex: 2, child: GroupInfoBox()))
              ],
            ),
          );
        });
  }
}

class ChatList extends ViewModelWidget<HomeViewModel> {
  const ChatList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, viewModel) {
    return Column(children: [
      Container(
        height: 65,
        color: Colors.grey.shade200,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  GestureDetector(
                      onTap: viewModel.onViewProfile,
                      child: CircleAvatar(
                        backgroundImage: viewModel.currentUser?.photoURL != null
                            ? NetworkImage(viewModel.currentUser!.photoURL!)
                            : null,
                      )),
                  Gap(10),
                  Text(
                    viewModel.username,
                    style: fontStyle.copyWith(fontSize: 18),
                  ),
                ],
              ),
              IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
            ],
          ),
        ),
      ),
      Gap(5),
      Expanded(
        child: SizedBox(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      StreamBuilder<List<GroupChatModel>>(
                          stream: viewModel.groupStream,
                          builder: (context, snapshot) {
                            print(snapshot.data?.first.created);
                            if (snapshot.data != null) {
                              if (snapshot.hasData) {
                                List<GroupChatModel> data = snapshot.data!;
                                return Column(
                                  children: List.generate(data.length, (index) {
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10.0),
                                      child: GroupCard(
                                        onTap: () => viewModel
                                            .onSelectGroup(data[index]),
                                        model: data[index],
                                      ),
                                    );
                                  }),
                                );
                              } else {
                                return Expanded(
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 30.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Text(
                                            "Oops! you do not belong to a Group Chat",
                                            textAlign: TextAlign.center,
                                            style: fontStyle.copyWith(
                                                fontSize: 16),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }
                            } else {
                              return Text(
                                "Oops! you do not belong to a Group Chat",
                                textAlign: TextAlign.center,
                                style: fontStyle.copyWith(fontSize: 16),
                              );
                            }
                          }),
                      Gap(20),
                      GButton(
                        title: "Create Group",
                        onPress: viewModel.showCreateDialog,
                      ),
                    ],
                  ),
                  Gap(10),
                  Text(
                    "Public Groups",
                    style: fontStyle.copyWith(
                        color: Colors.green.shade800,
                        fontSize: 20,
                        fontWeight: FontWeight.w600),
                  ),
                  Divider(),
                  Gap(5),
                  Column(
                    children:
                        List.generate(viewModel.publicGroups.length, (index) {
                      if (viewModel.publicGroups.isNotEmpty) {
                        return GroupCard(
                            onTap: () => viewModel
                                .onSelectGroup(viewModel.publicGroups[index]),
                            model: viewModel.publicGroups[index]);
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    }),
                  )
                ],
              ),
            ),
          ),
        ),
      )
    ]);
  }
}

class MessageStream extends ViewModelWidget<HomeViewModel> {
  const MessageStream({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, viewModel) {
    if (viewModel.selectedGroup != null) {
      return Column(
        children: [
          Container(
            color: Colors.grey.shade200,
            child: ListTile(
              onTap: viewModel.openGroupDetails,
              leading: CircleAvatar(
                backgroundImage: viewModel.selectedGroup!.dpUrl != null
                    ? NetworkImage(viewModel.selectedGroup!.dpUrl!)
                    : null,
              ),
              title: Text(
                viewModel.selectedGroup!.name!,
                style: fontStyle.copyWith(fontSize: 16),
              ),
              subtitle: Text(
                viewModel.selectedGroup!.desc!,
                style: fontStyle.copyWith(fontSize: 14),
              ),
              trailing: viewModel.isAMember(viewModel.selectedGroup!.members!)
                  ? viewModel.isAdmin
                      ? GestureDetector(
                          onTap: viewModel.showNewUserDialog,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                "Add Member",
                                style: fontStyle.copyWith(fontSize: 16),
                              ),
                            ),
                          ),
                        )
                      : GestureDetector(
                          onTap: viewModel.leaveGroup,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: !viewModel.busy(viewModel.leaveGroupDth)
                                  ? Text(
                                      "Leave",
                                      style: fontStyle.copyWith(fontSize: 16),
                                    )
                                  : CircularProgressIndicator(),
                            ),
                          ),
                        )
                  : null,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: SizedBox(
              child: Stack(
                children: [
                  Opacity(
                    opacity: 0.05,
                    child: Image.asset(
                      "assets/bg.jpg",
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Builder(builder: (context) {
                        if (viewModel.currChats.isNotEmpty) {
                          return Expanded(
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: viewModel.currChats.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ChatCard(
                                      model: viewModel.currChats[index],
                                      isUser:
                                          viewModel.currChats[index].sender ==
                                              viewModel.currentUser!.email!,
                                    ),
                                  );
                                }),
                          );
                        } else {
                          return Center(
                            child: Text(
                              "Start a chat",
                              style: fontStyle.copyWith(fontSize: 18),
                            ),
                          );
                        }
                      }),
                      if (viewModel
                          .isAMember(viewModel.selectedGroup!.members!))
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 10),
                          child: SizedBox(
                            child: Stack(
                              children: [
                                GTextField(
                                  hintText: "Message...",
                                  controller: viewModel.chatController,
                                ),
                                Positioned(
                                    right: 5,
                                    bottom: 5,
                                    child: IconButton(
                                        onPressed: viewModel.sendMessage,
                                        icon: const Icon(Icons.send))),
                              ],
                            ),
                          ),
                        ),
                      if (!viewModel
                          .isAMember(viewModel.selectedGroup!.members!))
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: Column(
                            children: [
                              Text(
                                "You are not a member of the of this group",
                                style: fontStyle.copyWith(
                                    fontSize: 16, color: Colors.green.shade800),
                              ),
                              Gap(10),
                              GButton(
                                title: "Join group",
                                isBusy: viewModel.busy(viewModel.joinGroupDth),
                                onPress: viewModel.joinGroup,
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      );
    } else {
      return Center(
        child: Text(
          "Welcome",
          style: fontStyle.copyWith(fontSize: 44),
        ),
      );
    }
  }
}

class GroupCard extends StatelessWidget {
  final GroupChatModel model;
  final void Function()? onTap;
  const GroupCard({Key? key, required this.model, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: onTap,
          leading: CircleAvatar(
            backgroundImage:
                model.dpUrl != null ? NetworkImage(model.dpUrl!) : null,
          ),
          title: Text(
            model.name ?? "",
            style: fontStyle.copyWith(fontSize: 16),
          ),
          subtitle: Text(
            model.lastMssg ?? "-",
            style: fontStyle.copyWith(fontSize: 16),
          ),
          trailing: Column(
            children: [
              Text(
                model.lastUpdatedTime?.toTime() ??
                    model.created?.toTime() ??
                    "-",
                style: fontStyle.copyWith(fontSize: 12),
              ),
            ],
          ),
        ),
        Divider(),
      ],
    );
  }
}

class ChatCard extends ViewModelWidget<HomeViewModel> {
  final bool isUser;
  final ChatModel model;
  const ChatCard({Key? key, this.isUser = false, required this.model})
      : super(key: key);

  @override
  Widget build(BuildContext context, viewModel) {
    Color _randomColor =
        Colors.primaries[Random().nextInt(Colors.primaries.length)];
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        decoration: BoxDecoration(
            color: isUser ? Colors.green.shade800 : Colors.blueGrey.shade800,
            borderRadius: BorderRadius.only(
              topLeft: isUser ? const Radius.circular(15) : Radius.zero,
              bottomLeft: const Radius.circular(15),
              bottomRight: const Radius.circular(15),
              topRight: isUser ? Radius.zero : const Radius.circular(15),
            )),
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            if (!isUser)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Text(
                  model.sender!,
                  textAlign: TextAlign.start,
                  style: fontStyle.copyWith(fontSize: 12, color: _randomColor),
                ),
              ),
            Text(
              model.text!,
              style: fontStyle.copyWith(fontSize: 14, color: Colors.white),
            ),
            Gap(10),
            Text(
              model.time!.toTime(),
              style: fontStyle.copyWith(fontSize: 8, color: Colors.white54),
              textAlign: TextAlign.end,
            )
          ],
        ),
      ),
    );
  }
}

class GroupInfoBox extends ViewModelWidget<HomeViewModel> {
  const GroupInfoBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          height: 65,
          padding: EdgeInsets.all(10),
          // color: Colors.grey.shade200,
          child: Row(
            children: [
              IconButton(
                  onPressed: viewModel.closeGroupDetails,
                  icon: const Icon(Icons.clear)),
              Text(
                "Group Details",
                style: fontStyle.copyWith(fontSize: 18),
              )
            ],
          ),
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Builder(builder: (context) {
                  if (viewModel.selectedGroup!.dpUrl != null &&
                      viewModel.groupDp == null) {
                    return GestureDetector(
                      onTap: viewModel.pickGroupDp,
                      child: CachedNetworkImage(
                        imageUrl: viewModel.selectedGroup!.dpUrl!,
                        imageBuilder: (context, imageProvider) {
                          return CircleAvatar(
                            backgroundColor: Colors.grey.shade400,
                            radius: 100,
                            backgroundImage: imageProvider,
                          );
                        },
                        fit: BoxFit.scaleDown,
                        placeholder: (context, url) => const Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Center(child: CircularProgressIndicator()),
                        ),
                      ),
                    );
                  } else {
                    return GestureDetector(
                      onTap: viewModel.isAdmin ? viewModel.pickGroupDp : null,
                      child: CircleAvatar(
                        radius: 100,
                        backgroundColor: Colors.grey.shade500,
                        backgroundImage: viewModel.groupDp != null
                            ? MemoryImage(viewModel.groupDp!)
                            : null,
                        child: viewModel.isAdmin && viewModel.groupDp == null
                            ? const Icon(
                                Icons.camera_alt,
                                size: 100,
                                color: Colors.white,
                              )
                            : const Icon(Icons.people_alt_sharp,
                                size: 100, color: Colors.white),
                      ),
                    );
                  }
                }),
                Gap(10),
                Text(
                  viewModel.selectedGroup!.name!,
                  style: fontStyle,
                ),
                Text(
                  "${viewModel.selectedGroup!.members!.length} participants",
                  style: fontStyle.copyWith(fontSize: 18),
                )
              ],
            ),
          ),
        ),
        Gap(10),
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Text(
                        "Description: ",
                        style: fontStyle.copyWith(
                            color: Colors.green.shade800, fontSize: 16),
                      ),
                      Expanded(
                        child: Text(
                          viewModel.selectedGroup!.desc!,
                          style: fontStyle.copyWith(fontSize: 16),
                        ),
                      )
                    ],
                  ),
                  Divider(),
                  Gap(15),
                  Text(
                    "Members",
                    style: fontStyle.copyWith(
                        color: Colors.green.shade800, fontSize: 18),
                  ),
                  Gap(10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: List.generate(
                        viewModel.selectedGroup!.members!.length,
                        (index) => Row(
                              children: [
                                Text(
                                  viewModel.selectedGroup!.members![index],
                                  style: fontStyle.copyWith(fontSize: 16),
                                ),
                                if (viewModel.selectedGroup!.admin ==
                                    viewModel.selectedGroup!.members![index])
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: Colors.grey)),
                                    padding: EdgeInsets.all(8),
                                    margin: EdgeInsets.only(left: 8),
                                    child: Text(
                                      "Admin",
                                      style: fontStyle.copyWith(
                                          color: Colors.green.shade800,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  )
                              ],
                            )),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}

class ProfileBox extends ViewModelWidget<HomeViewModel> {
  const ProfileBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, viewModel) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Container(
            height: 60,
            color: Colors.grey.shade200,
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                IconButton(
                    onPressed: viewModel.closeProfile,
                    icon: const Icon(Icons.arrow_back)),
                Gap(10),
                Text(
                  "Profile",
                  style: fontStyle,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Gap(40),
                Builder(builder: (context) {
                  if (viewModel.currentUser?.photoURL != null &&
                      viewModel.userDp == null) {
                    return GestureDetector(
                      onTap: viewModel.pickUserDp,
                      child: CachedNetworkImage(
                        imageUrl: viewModel.currentUser!.photoURL!,
                        imageBuilder: (context, imageProvider) {
                          return CircleAvatar(
                            backgroundColor: Colors.grey.shade400,
                            radius: 100,
                            backgroundImage: imageProvider,
                          );
                        },
                        fit: BoxFit.scaleDown,
                        placeholder: (context, url) => const Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Center(child: CircularProgressIndicator()),
                        ),
                      ),
                    );
                  } else {
                    return GestureDetector(
                      onTap: viewModel.pickUserDp,
                      child: CircleAvatar(
                        radius: 100,
                        backgroundColor: Colors.grey.shade500,
                        backgroundImage: viewModel.userDp != null
                            ? MemoryImage(viewModel.userDp!)
                            : null,
                        child: viewModel.userDp == null
                            ? const Icon(
                                Icons.camera_alt,
                                size: 100,
                                color: Colors.white,
                              )
                            : null,
                      ),
                    );
                  }
                }),
                Gap(20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Username",
                      style: fontStyle.copyWith(
                          color: Colors.green.shade800, fontSize: 12),
                    ),
                    Gap(10),
                    Text(
                      viewModel.username,
                      style: fontStyle.copyWith(fontSize: 16),
                    ),
                  ],
                ),
                Divider(),
                Gap(10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "About",
                      style: fontStyle.copyWith(
                          color: Colors.green.shade800, fontSize: 12),
                    ),
                    Gap(10),
                    Text(
                      "This is about the user",
                      style: fontStyle.copyWith(fontSize: 16),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

TextStyle fontStyle = GoogleFonts.poppins(fontSize: 24);
