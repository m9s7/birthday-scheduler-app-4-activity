import 'package:birthday_scheduler/features/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

class GeneralDrawer extends ConsumerWidget {
  final bool isAuthenticated;
  const GeneralDrawer({super.key, required this.isAuthenticated});

  void logOut(WidgetRef ref) {
    ref.read(authControllerProvider.notifier).logout();
  }

  void navigateToAdminPanel(BuildContext context) {
    Routemaster.of(context).push('admin');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (isAuthenticated)
            ListTile(
              title: const Text("Autorizovana lista"),
              leading: const Icon(Icons.work_history_outlined),
              onTap: () => navigateToAdminPanel(context),
            ),
          ListTile(
            title: const Text("Izloguj se"),
            leading: const Icon(Icons.logout, color: Colors.red),
            onTap: () => logOut(ref),
          )
        ],
      )),
    );
  }
}
