import 'package:web_groupchat/core/repo/user_repo.dart';

import '../model/user_model.dart';

class UserService{
   final UserRepo _userRepo = UserRepo();
   UserModel? _user;

   UserModel? get user => _user;

   // String _username = "";
   String _email ="";

   void initCred(String email){
      _email = email;
   }

   // void initEMainEtUsername(String email, String username){
   //    _email = email;
   //    _username = username;
   // }

Future<void> getUserDetails() async{
   _user =  await _userRepo.getUserDetails(_email);
}

void createUser(UserModel user) async{
      print(user.email);
  await _userRepo.createUser(user.email!, user);
   getUserDetails();
}

// String get userId {
// return username+email;
// }

}