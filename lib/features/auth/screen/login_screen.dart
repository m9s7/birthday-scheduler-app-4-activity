import 'package:birthday_scheduler/core/common/loader.dart';
import 'package:birthday_scheduler/core/common/sign_in_button.dart';
import 'package:birthday_scheduler/core/constants/constants.dart';
import 'package:birthday_scheduler/features/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(authControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Activity Birthday Scheduler"),
        centerTitle: true,
      ),
      body: isLoading
          ? const Loader()
          : Column(
              children: [
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    Constants.logoPath,
                    height: 400,
                  ),
                ),
                const SizedBox(height: 20),
                const SignInButton()
              ],
            ),
    );
  }
}
