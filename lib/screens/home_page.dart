import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:vietnam_history/models/auth_model.dart';
import 'package:vietnam_history/screens/era_selection_page.dart';
import 'package:vietnam_history/screens/intro_page.dart';
import 'package:vietnam_history/screens/login_page.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Check if the user is already signed in
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final AuthModel authModel = Provider.of<AuthModel>(context, listen: true);
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.data != null) {
          return IntroPage(); // User is signed in
        } else {
          Navigator.popUntil(context, (route) => route.isFirst);
          return const LoginPage(); // User is not signed in
        }
      },
    );
  }
}
