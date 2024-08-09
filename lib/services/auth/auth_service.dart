import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:socially/services/exceptions/exceptions.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Sign in anonymously

  Future<void> signInAnonymously() async {
    try {
      final userCredential = await _auth.signInAnonymously();
      final user = userCredential.user;
      if (user != null) {
        print('Signed in anonymously: ${user.uid}');
      }
    } catch (e) {
      print('Error signing in anonymously: $e');
    }
  }

  //sign in anonymously with auth exceptions
  Future<void> signInAnonymouslywithExceptions() async {
    try {
      final userCredential = await _auth.signInAnonymously();
      final user = userCredential.user;
      if (user != null) {
        print('Signed in anonymously: ${user.uid}');
      }
    } on FirebaseAuthException catch (e) {
      print(
          'Error signing in anonymously: ${mapFirebaseAuthExceptionCode(e.code)}');
      throw Exception(mapFirebaseAuthExceptionCode(e.code));
    } catch (e) {
      print('Error signing in anonymously: $e');
    }
  }

  // Sign out

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      print('Signed out');
    } on FirebaseAuthException catch (e) {
      print('Error signing out: ${mapFirebaseAuthExceptionCode(e.code)}');
      throw Exception(mapFirebaseAuthExceptionCode(e.code));
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  // Get the current user

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  //create user with email and password

  Future<UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      print('Error creating user: ${mapFirebaseAuthExceptionCode(e.code)}');
      throw Exception(mapFirebaseAuthExceptionCode(e.code));
    } catch (e) {
      print('Error creating user: $e');
      throw Exception(e.toString());
    }
  }

  //sign in with email and password

  Future<void> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      print('Error signing in: ${mapFirebaseAuthExceptionCode(e.code)}');

      throw Exception(mapFirebaseAuthExceptionCode(e.code));
    } catch (e) {
      print('Error signing in: $e');
    }
  }

  //sign in with google

  Future<void> signInWithGoogle() async {
    try {
      // Trigger the Google Sign In process
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // User canceled the sign-in
        return;
      }

      // Obtain the GoogleSignInAuthentication object
      final googleAuth = await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google Auth credential
      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        // Prepare user data
        final userData = {
          'userId': user.uid,
          'name': user.displayName ?? 'No Name',
          'email': user.email ?? 'No Email',
          'jobTitle': 'jobTitle',
          'imageUrl': user.photoURL ?? '',
          'createdAt': Timestamp.fromDate(DateTime.now()),
          'updatedAt': Timestamp.fromDate(DateTime.now()),
          'password': '', // Password is not needed for Google sign-in
          'followers': 0,
        };

        // Save user to Firestore
        final userDocRef =
            FirebaseFirestore.instance.collection('users').doc(user.uid);
        await userDocRef.set(userData);
      }
    } on FirebaseAuthException catch (e) {
      print(
          'Error signing in with Google: ${mapFirebaseAuthExceptionCode(e.code)}');
      throw Exception(mapFirebaseAuthExceptionCode(e.code));
    } catch (e) {
      print('Error signing in with Google: $e');
    }
  }

  //github sign in

  Future<void> signInWithGitHub() async {
    try {
      GithubAuthProvider githubAuthProvider = GithubAuthProvider();
      await FirebaseAuth.instance.signInWithProvider(githubAuthProvider);
    } on FirebaseAuthException catch (e) {
      print(
          'Error signing in with GitHub: ${mapFirebaseAuthExceptionCode(e.code)}');
      throw Exception(mapFirebaseAuthExceptionCode(e.code));
    } catch (e) {
      print('Error signing in with GitHub: $e');
    }
  }

  // Send password reset email

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      print('Password reset email sent to $email');
    } on FirebaseAuthException catch (e) {
      print(
          'Error sending password reset email: ${mapFirebaseAuthExceptionCode(e.code)}');
    } catch (e) {
      print('Error sending password reset email: $e');
    }
  }
}
