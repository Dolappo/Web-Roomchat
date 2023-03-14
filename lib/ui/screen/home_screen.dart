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
                      child: const CircleAvatar()),
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
        child: Column(
          children: [
            StreamBuilder<List<GroupChatModel>>(
                stream: viewModel.groupStream,
                builder: (context, snapshot) {
                  print(snapshot.data?.first.created);
                  if (snapshot.data != null) {
                    if (snapshot.hasData) {
                      List<GroupChatModel> data = snapshot.data!;
                      return ListView.builder(
                          itemCount: data.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: GroupCard(
                                onTap: () =>
                                    viewModel.onSelectGroup(data[index]),
                                model: data[index],
                              ),
                            );
                          });
                    } else {
                      return Expanded(
                        child: Center(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 30.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  "Oops! you do not belong to a Group Chat",
                                  textAlign: TextAlign.center,
                                  style: fontStyle.copyWith(fontSize: 16),
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
              leading: CircleAvatar(),
              title: Text(
                viewModel.selectedGroup!.name!,
                style: fontStyle.copyWith(fontSize: 16),
              ),
              subtitle: Text(
                viewModel.selectedGroup!.desc!,
                style: fontStyle.copyWith(fontSize: 14),
              ),
              trailing: IconButton(
                icon: Icon(Icons.search),
                onPressed: () {},
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: Column(
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
                                isUser: viewModel.currChats[index].sender ==
                                    viewModel.currentUser,
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
                )
              ],
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
    return Container(
      color: Colors.white,
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(),
        title: Text(
          model.name!,
          style: fontStyle.copyWith(fontSize: 16),
        ),
        subtitle: Text(
          model.lastMssg ?? "-",
          style: fontStyle.copyWith(fontSize: 16),
        ),
        trailing: Column(
          children: [
            Text(
              model.lastUpdatedTime?.toTime() ?? model.created?.toTime() ?? "-",
              style: fontStyle.copyWith(fontSize: 12),
            ),
          ],
        ),
      ),
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
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        decoration: BoxDecoration(
            color: isUser ? Colors.green.shade800 : Colors.black54,
            borderRadius: BorderRadius.only(
              topLeft: isUser ? const Radius.circular(15) : Radius.zero,
              bottomLeft: const Radius.circular(15),
              bottomRight: const Radius.circular(15),
              topRight: isUser ? Radius.zero : const Radius.circular(15),
            )),
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Text(
              model.text!,
              style: fontStyle.copyWith(fontSize: 14, color: Colors.white),
            ),
            Gap(10),
            Text(
              model.time!.toTime(),
              style: fontStyle.copyWith(fontSize: 8, color: Colors.white54),
              textAlign: TextAlign.right,
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
          color: Colors.grey.shade200,
          child: Row(
            children: [
              IconButton(
                  onPressed: viewModel.closeGroupDetails,
                  icon: Icon(Icons.clear)),
              Text(
                "Group Details",
                style: fontStyle,
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
                CircleAvatar(
                  radius: 100,
                  backgroundColor: Colors.grey.shade500,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                        ),
                        Text(
                          "Add group Icon".toUpperCase(),
                          style: fontStyle.copyWith(
                              color: Colors.white, fontSize: 16),
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                ),
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
                        "Description:",
                        style: fontStyle.copyWith(
                            color: Colors.green.shade800, fontSize: 16),
                      ),
                      Text(
                        viewModel.selectedGroup!.desc!,
                        style: fontStyle.copyWith(fontSize: 16),
                      )
                    ],
                  ),
                  Gap(15),
                  Text(
                    "Members",
                    style: fontStyle.copyWith(
                        color: Colors.green.shade800, fontSize: 18),
                  ),
                  Divider(),
                  Gap(10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: List.generate(
                        viewModel.selectedGroup!.members!.length,
                        (index) => Text(
                              viewModel.selectedGroup!.members![index],
                              style: fontStyle.copyWith(fontSize: 16),
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
                CircleAvatar(
                  radius: 100,
                ),
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
