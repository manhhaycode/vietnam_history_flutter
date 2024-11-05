import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:vietnam_history/utils/dio_client.dart';

class AuthModel with ChangeNotifier {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final _storage = const FlutterSecureStorage();
  final _dio = DioClient.instance;
  static User? _user;
  String? _errorMessage; // Variable to store error messages
  bool _isSigningIn = false; // Variable to track signing in state

  User? get user => _user;
  String? get errorMessage => _errorMessage;
  bool get isSigningIn => _isSigningIn;

  // Stream to listen for user changes
  Stream<GoogleSignInAccount?> get userStream =>
      _googleSignIn.onCurrentUserChanged;

  Future<void> signIn() async {
    _isSigningIn = true; // Set signing in state to true
    notifyListeners(); // Notify listeners about the change

    try {
      var user = await _googleSignIn.signIn();
      if (user == null) {
        print('Google sign-in aborted or failed.');
        return; // Exit if googleUser is null
      }

      GoogleSignInAuthentication? googleAuth = await user.authentication;

      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      var token = await userCredential.user?.getIdToken(true);
      _storage.write(
          key: 'token', value: token); // Save the token to secure storage

      var response = await _dio.post('api/v1/auth/login-firebase');
      if (response.statusCode == 200) {
        print('Login success');
      } else {
        print('Login failed');
      }

      _errorMessage = null; // Clear any previous error messages
    } catch (error) {
      _errorMessage = error.toString(); // Capture error message
      print(error); // Handle error
    } finally {
      _isSigningIn = false; // Reset signing in state
      notifyListeners(); // Notify listeners about the change
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await FirebaseAuth.instance.signOut();
    _user = null; // Clear user data
    _errorMessage = null; // Clear error message
    notifyListeners(); // Notify listeners about the change
  }

  bool get isLoggedIn => _user != null; // Check if user is logged in

  Future<void> disconnect() async {
    await _googleSignIn.disconnect(); // Disconnect the user
    _user = null; // Clear user data
    notifyListeners(); // Notify listeners about the change
  }

  set user(User? value) {
    _user = value;
    notifyListeners(); // Notify listeners about the change
  }
}
