import 'package:birthday_scheduler/features/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GeneralDrawer extends ConsumerWidget {
  const GeneralDrawer({super.key});

  void logOut(WidgetRef ref) {
    ref.read(authControllerProvider.notifier).logout();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // ListTile(
          //   title: const Text("Dodatne informacije"),
          //   leading: const Icon(Icons.work_history_outlined),
          //   onTap: () {},
          // ),
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
