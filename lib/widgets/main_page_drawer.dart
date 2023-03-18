import 'package:flutter/material.dart';

class MainPageDrawer extends StatelessWidget {
  final String user;
  final void Function() onLogoutPressed;

  const MainPageDrawer(
      {super.key, required this.user, required this.onLogoutPressed});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.blue),
            child: Center(
              child: Column(children: [
                Expanded(child: Image.asset('assets/logo.png')),
                const SizedBox(height: 10),
                const Text(
                  "Configurações",
                  style: TextStyle(color: Colors.white),
                )
              ]),
            ),
          ),
          ListTile(
            title: Column(
              children: [
                const SizedBox(height: 20),
                Text('Usuario: $user'),
                const SizedBox(height: 20),
                TextButton(
                    onPressed: onLogoutPressed, child: const Text('Sair')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
