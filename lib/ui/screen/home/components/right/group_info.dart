import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:stacked/stacked.dart';

import '../../home_screen.dart';
import '../../home_view_model.dart';

class GroupInfoBox extends ViewModelWidget<HomeViewModel> {
  const GroupInfoBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          height: 65,
          padding: const EdgeInsets.all(10),
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
                      viewModel.groupDp == null &&
                      viewModel.isAdmin) {
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
                  } else if (viewModel.selectedGroup!.dpUrl == null &&
                      viewModel.isAdmin) {
                    return GestureDetector(
                      onTap: viewModel.pickGroupDp,
                      child: CircleAvatar(
                        radius: 100,
                        backgroundColor: Colors.grey.shade500,
                        backgroundImage: viewModel.groupDp == null
                            ? null
                            : MemoryImage(viewModel.groupDp!),
                        child: viewModel.groupDp != null
                            ? null
                            : const Icon(Icons.camera_alt,
                                size: 100, color: Colors.white),
                      ),
                    );
                  } else {
                    return GestureDetector(
                      onTap: null,
                      child: CircleAvatar(
                        radius: 100,
                        backgroundColor: Colors.grey.shade500,
                        backgroundImage: viewModel.groupDp != null
                            ? MemoryImage(viewModel.groupDp!)
                            : null,
                        child: const Icon(Icons.people_alt_sharp,
                            size: 100, color: Colors.white),
                      ),
                    );
                  }
                }),
                const Gap(10),
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
        const Gap(10),
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
                  const Divider(),
                  const Gap(15),
                  Text(
                    "Members",
                    style: fontStyle.copyWith(
                        color: Colors.green.shade800, fontSize: 18),
                  ),
                  const Gap(10),
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
                                    padding: const EdgeInsets.all(8),
                                    margin: const EdgeInsets.only(left: 8),
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
