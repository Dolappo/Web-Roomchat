import 'package:flutter/material.dart';
import 'package:web_groupchat/utils/extension.dart';
import '../../../core/model/chat_model.dart';
import '../../screen/home/home_screen.dart';

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
            style: fontStyle.copyWith(fontSize: 12),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
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
