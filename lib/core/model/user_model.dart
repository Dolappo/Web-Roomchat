import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()

class UserModel{
  String? email;
  String? username;
  UserModel({this.email, this.username});

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}