import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final currentRoute = ModalRoute.of(context)?.settings.name ?? '/';

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'ALD Machine Control',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Dashboard'),
            selected: currentRoute == '/',
            onTap: () {
              // 1) Close the drawer (pops the drawer route/overlay).
              Navigator.pop(context);

              // 2) If we're NOT already on '/', then navigate.
              if (currentRoute != '/') {
                Navigator.pushReplacementNamed(context, '/');
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.precision_manufacturing),
            title: const Text('Machines'),
            selected: currentRoute == '/machines',
            onTap: () {
              Navigator.pop(context);
              if (currentRoute != '/machines') {
                Navigator.pushReplacementNamed(context, '/machines');
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.receipt_long),
            title: const Text('Recipes'),
            selected: currentRoute == '/recipes',
            onTap: () {
              Navigator.pop(context);
              if (currentRoute != '/recipes') {
                Navigator.pushReplacementNamed(context, '/recipes');
              }
            },
          ),
        ],
      ),
    );
  }
}
