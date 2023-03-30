import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/user_model.dart';
import '../services/firestore_service.dart';

class UserRepo {
  final _fstore = FirestoreService();

  Future<UserModel?> getUserDetails(String id) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _fstore.userCollection.doc(id).get();
    return UserModel.fromJson(snapshot.data()!);
  }

  Future<void> createUser(String userId, UserModel user) async {
    await _fstore.userCollection.doc(userId).set(user.toJson());
  }
}
