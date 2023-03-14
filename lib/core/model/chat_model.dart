import 'package:web_groupchat/core/enum/chat_type.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chat_model.g.dart';

@JsonSerializable()
class GroupChatModel{
  String? name;
  ChatType? type;
  DateTime? lastUpdatedTime;
  String? lastMssg;
  String? id;
  DateTime? created;
  String? admin;
  List<String>? members;
  String? dpUrl;
  String? desc;
  GroupChatModel({
    this.lastMssg,
    this.dpUrl,
    this.id,
    this.desc,
    this.name,
    this.type,
    this.lastUpdatedTime,
    this.members,
    this.created,
    this.admin
});

  factory GroupChatModel.fromJson(Map<String, dynamic> json) => _$GroupChatModelFromJson(json);

  Map<String, dynamic> toJson() => _$GroupChatModelToJson(this);
}