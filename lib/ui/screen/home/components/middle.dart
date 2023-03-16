import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:stacked/stacked.dart';

import '../../../widgets/button.dart';
import '../../../widgets/home/chat_bubble.dart';
import '../../../widgets/textfield.dart';
import '../home_screen.dart';
import '../home_view_model.dart';

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
                                  : const CircularProgressIndicator(),
                            ),
                          ),
                        )
                  : null,
            ),
          ),
          const SizedBox(
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
                              const Gap(10),
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
