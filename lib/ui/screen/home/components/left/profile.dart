import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:stacked/stacked.dart';
import '../../home_screen.dart';
import '../../home_view_model.dart';

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
