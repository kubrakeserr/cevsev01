import 'package:cevsev01/model/user_model.dart';
import 'package:cevsev01/services/auth_base.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthService implements AuthBase{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<User> currentUser() async{

    try{
      FirebaseUser user = await _firebaseAuth.currentUser();
      return _userFromFirebase(user);
    }catch(e){
      print("HATA CURRENT USER" + e.toString());
      return null;
    }

  }

  User _userFromFirebase(FirebaseUser user){
    if(user == null)
      return null;
    return User(userId: user.uid);
  }


  @override
  Future<User> signInAnonymously() async{
    try{
      AuthResult sonuc = await _firebaseAuth.signInAnonymously();
      return _userFromFirebase(sonuc.user);
    }catch(e){
      print("anonim giriş hata:" + e.toString());
      return null;
    }

  }

  @override
  Future<bool> signOut() async {
    try {
      final _googleSignIn = GoogleSignIn();
      await _googleSignIn.signOut();
      await _firebaseAuth.signOut();
      return true;
    } catch (e) {
      print("sign out hata:" + e.toString());
      return false;
    }
  }

  @override
  Future<User> signInWithGoogle()async {
    GoogleSignIn _googleSignIn = GoogleSignIn();
    GoogleSignInAccount _googleUser = await _googleSignIn.signIn();

    if(_googleUser != null)
    {
      GoogleSignInAuthentication _googleAuth = await _googleUser.authentication;
      if(_googleAuth.idToken != null && _googleAuth.accessToken != null)
      {
        AuthResult sonuc = await _firebaseAuth.signInWithCredential(
          GoogleAuthProvider.getCredential(
              idToken: _googleAuth.idToken,
              accessToken: _googleAuth.accessToken));
        FirebaseUser _user = sonuc.user;
        return _userFromFirebase(_user);
      }else{
        return null;
      }
    }else{
      return null;
    }
    //Google ile giriş yaptık..authentication verileri ile oturum açabilicez...

  }

  @override
  Future<User> CreateWithEmailandPassword(String email, String password) {
    // TODO: implement CreateWithEmailandPassword
    throw UnimplementedError();
  }

  @override
  Future<User> signInWithEmailandPassword(String email, String password) {
    // TODO: implement signInWithEmailandPassword
    throw UnimplementedError();
  }
}