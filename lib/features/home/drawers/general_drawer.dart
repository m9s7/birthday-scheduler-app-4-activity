import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GeneralDrawer extends ConsumerWidget {
  const GeneralDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ListTile(
            title: const Text("Additional features"),
            leading: const Icon(Icons.work_history_outlined),
            onTap: () {},
          ),
          ListTile(
            title: const Text("Log out"),
            leading: const Icon(Icons.logout, color: Colors.red),
            onTap: () {},
          )
        ],
      )),
    );
  }
}
