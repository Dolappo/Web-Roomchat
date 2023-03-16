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
