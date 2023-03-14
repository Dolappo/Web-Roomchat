import 'package:firebase_auth/firebase_auth.dart';
import 'package:web_groupchat/core/enum/auth_card.dart';
class AuthService{
  final FirebaseAuth _fInstance = FirebaseAuth.instance;

  User? get currentUser => _fInstance.currentUser;

  AuthCard _currentPage = AuthCard.register;

  AuthCard get currentPage => _currentPage;

  set authPage(AuthCard page){
    _currentPage = page;
  }

  Future<String> registerWithEmail(String email, String password) async {
   try{
     await _fInstance.createUserWithEmailAndPassword(
         email: email, password: password);
     return "Registration Successful";
   }
   on FirebaseAuthException catch(e){
     print(e);
     return e.toString();
   }
  }

  Future<String> loginWithEmail(String email, String password) async {
    try {
     UserCredential user =  await _fInstance.signInWithEmailAndPassword(
          email: email, password: password);
       return "Login Successful";
    } on FirebaseAuthException catch (e) {
      print(e);
      return e.toString();
    }
  }

  Future<void> logout() async {
    await _fInstance.signOut();
  }
}