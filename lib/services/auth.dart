import 'package:firebase_auth/firebase_auth.dart';
import 'package:sketch/model/user.dart';
import 'package:sketch/services/database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Create MyUser object based on a FirebaseUser
  MyUser? myUserFromFirebaseUser(User? user) {
    if (user != null && !user.emailVerified) {
      return null;
    }
    return (user != null ? MyUser(uid: user.uid) : null);
  }

  // Auth change MyUser stream
  Stream<MyUser?> get user {
    return _auth.authStateChanges().map(myUserFromFirebaseUser);
  }

  // Get user uid
  String get currentUserUid {
    return _auth.currentUser!.uid;
  }

  // Password reset
  Future sendPasswordReset(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
    }
  }

  // Sign in with email & password
  Future signInWithEmailPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Check if document exist
  Future<bool> checkUserSetup() async {
    return (await DatabaseService(uid: _auth.currentUser!.uid)
        .checkProfilExist());
  }

  // Register in with email & password
  Future registerWithEmailPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Update user profil
  Future updateUserProfil(
      String firstname, String lastname, String picture) async {
    await DatabaseService(uid: _auth.currentUser!.uid)
        .updateUserProfil(firstname, lastname, picture);
  }

  // Sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Send verification email
  Future sendVerificationEmail() async {
    final user = FirebaseAuth.instance.currentUser!;
    await user.sendEmailVerification();
  }

  // Firebase error to string
  String getMessageFromErrorCode(dynamic error) {
    switch (error) {
      case "ERROR_EMAIL_ALREADY_IN_USE":
      case "account-exists-with-different-credential":
      case "email-already-in-use":
        return "Email already used. Go to login page.";
      case "ERROR_WRONG_PASSWORD":
      case "wrong-password":
        return "Wrong email/password combination.";
      case "ERROR_USER_NOT_FOUND":
      case "user-not-found":
        return "No user found with this email.";
      case "ERROR_USER_DISABLED":
      case "user-disabled":
        return "User disabled.";
      case "ERROR_TOO_MANY_REQUESTS":
      case "operation-not-allowed":
        return "Too many requests to log into this account.";
      case "ERROR_OPERATION_NOT_ALLOWED":
      // ignore: no_duplicate_case_values
      case "operation-not-allowed":
        return "Server error, please try again later.";
      case "ERROR_INVALID_EMAIL":
      case "invalid-email":
        return "Email address is invalid.";
      default:
        return "Login failed. Please try again.";
    }
  }
}
