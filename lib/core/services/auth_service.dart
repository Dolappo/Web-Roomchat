import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:web_groupchat/core/enum/auth_card.dart';

class AuthService {
  final FirebaseAuth _fInstance = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  GoogleAuthProvider authProvider = GoogleAuthProvider();

  void init() async {
    GoogleSignInAccount? signInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication? signInAuthentication =
        await signInAccount?.authentication;
  }

  Future<User?> signInWithGoogle() async {
    User? user;
    try {
      UserCredential userCre = await _fInstance.signInWithPopup(authProvider);
      user = userCre.user;
    } on FirebaseAuthException catch (e) {
      print(e);
    }
    return user;
  }

  User? get currentUser => _fInstance.currentUser;

  AuthCard _currentPage = AuthCard.register;

  AuthCard get currentPage => _currentPage;

  set authPage(AuthCard page) {
    _currentPage = page;
  }

  Future<User?> registerWithEmail(
      String email, String password, String username) async {
    User? user;
    try {
      UserCredential userCre = await _fInstance.createUserWithEmailAndPassword(
          email: email, password: password);
      user = userCre.user;
      await user!.updateDisplayName(username);
      await user.reload();
    } on FirebaseAuthException catch (e) {
      print(e);
    }
    return user;
  }

  Future<void> updateUserDetails({String? username}) async {
    if (username != null) {
      await _fInstance.currentUser!.updateDisplayName(username);
    }
  }

  Future<void> updateUserPhotoUrl(String imgUrl) async {
    await _fInstance.currentUser!.updatePhotoURL(imgUrl);
  }

  Future<User?> loginWithEmail(String email, String password) async {
    User? user;
    try {
      UserCredential userCre = await _fInstance.signInWithEmailAndPassword(
          email: email, password: password);
      user = userCre.user;
    } on FirebaseAuthException catch (e) {
      print(e);
    }
    return user;
  }

  Future<void> logout() async {
    await _fInstance.signOut();
  }
}
