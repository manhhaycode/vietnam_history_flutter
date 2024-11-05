import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vietnam_history/models/auth_model.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const CustomAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final AuthModel authModel = Provider.of<AuthModel>(context, listen: true);

    return AppBar(
      title: Text(title),
      centerTitle: true,
      backgroundColor: Colors.blue,
      actions: [
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () async {
            await authModel.signOut();
            // Optionally, you can navigate to a login screen or show a message
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
