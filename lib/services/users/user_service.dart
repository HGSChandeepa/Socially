import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:socially/models/user_model.dart';
import 'package:socially/services/auth/auth_service.dart';

class UserService {
  // Create a collection reference
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');

  // Save the user in the Firestore database
  Future<void> saveUser(User user) async {
    try {
      //create a new user with email and password
      await AuthService().createUserWithEmailAndPassword(
        email: user.email,
        password: user.password,
      );

      // Add the user to the collection
      final docRef = await _usersCollection.add(user.toMap());
      await docRef.update({'userId': docRef.id});

      print('User saved successfully');
    } catch (error) {
      print('Error saving user: $error');
    }
  }
}
