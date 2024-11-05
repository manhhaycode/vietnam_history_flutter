import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vietnam_history/models/auth_model.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authModel = Provider.of<AuthModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login with Google'),
      ),
      body: Center(
        child: authModel.isSigningIn
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (authModel.errorMessage != null)
                    Text(
                      'Error: ${authModel.errorMessage}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ElevatedButton(
                    onPressed: () async {
                      await authModel.signIn();
                    },
                    child: const Text('Sign in with Google'),
                  ),
                ],
              ),
      ),
    );
  }
}
