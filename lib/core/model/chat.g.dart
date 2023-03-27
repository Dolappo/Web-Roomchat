// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatModel _$ChatModelFromJson(Map<String, dynamic> json) => ChatModel(
      text: json['text'] as String?,
      sender: json['sender'] as String?,
      time:
          json['time'] == null ? null : DateTime.parse(json['time'] as String),
    )..id = json['id'] as String?;

Map<String, dynamic> _$ChatModelToJson(ChatModel instance) => <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'time': instance.time?.toIso8601String(),
      'sender': instance.sender,
    };
