import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vietnam_history/screens/era_selection_page.dart';

class IntroPage extends StatelessWidget {
  IntroPage({super.key});

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    User? user = _auth.currentUser; // Get the current user

    return Scaffold(
      appBar: AppBar(title: const Text('User Information')),
      body: Center(
        child: user != null // Check if user is not null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Display user avatar
                  CircleAvatar(
                    radius: 50, // Adjust the radius as needed
                    backgroundImage: user.photoURL != null
                        ? NetworkImage(user.photoURL!) // Load image from URL
                        : const AssetImage('assets/default_avatar.png')
                            as ImageProvider, // Default avatar if no photo
                  ),
                  const SizedBox(height: 20),
                  Text('Welcome, ${user.displayName ?? "User"}'),
                  Text('Email: ${user.email}'),
                  Text('UID: ${user.uid}'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EraSelectionPage(),
                        ),
                      );
                    },
                    child: const Text('Continue'),
                  ),
                ],
              )
            : const Text('No user is signed in.'),
      ),
    );
  }
}
