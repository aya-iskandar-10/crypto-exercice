import 'package:crypto_exercice/services/firebase/auth_service.dart';
import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});
  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool _busy = false;

  Future<void> _login() async {
    setState(() => _busy = true);
    try {
      await AuthService().signInWithGoogle(); // AuthGate reacts by itself
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Sign-in failed: $e')));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: _busy
              ? const CircularProgressIndicator()
              : FilledButton.icon(
                  onPressed: _login,
                  icon: const Icon(Icons.login),
                  label: const Text('Sign in with Google'),
                ),
        ),
      );
}