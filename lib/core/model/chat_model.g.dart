// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GroupChatModel _$GroupChatModelFromJson(Map<String, dynamic> json) =>
    GroupChatModel(
      lastMssg: json['lastMssg'] as String?,
      dpUrl: json['dpUrl'] as String?,
      id: json['id'] as String?,
      desc: json['desc'] as String?,
      name: json['name'] as String?,
      type: $enumDecodeNullable(_$ChatTypeEnumMap, json['type']),
      lastUpdatedTime: json['lastUpdatedTime'] == null
          ? null
          : DateTime.parse(json['lastUpdatedTime'] as String),
      members:
          (json['members'] as List<dynamic>?)?.map((e) => e as String).toList(),
      created: json['created'] == null
          ? null
          : DateTime.parse(json['created'] as String),
      admin: json['admin'] as String?,
    );

Map<String, dynamic> _$GroupChatModelToJson(GroupChatModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'type': _$ChatTypeEnumMap[instance.type],
      'lastUpdatedTime': instance.lastUpdatedTime?.toIso8601String(),
      'lastMssg': instance.lastMssg,
      'id': instance.id,
      'created': instance.created?.toIso8601String(),
      'admin': instance.admin,
      'members': instance.members,
      'dpUrl': instance.dpUrl,
      'desc': instance.desc,
    };

const _$ChatTypeEnumMap = {
  ChatType.public: 'public',
  ChatType.private: 'private',
};
