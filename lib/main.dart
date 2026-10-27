import 'package:crypto_exercice/controller/crypto_controller.dart';
import 'package:crypto_exercice/firebase_options.dart';
import 'package:crypto_exercice/services/firebase/auth_service.dart';
import 'package:crypto_exercice/services/firebase/favorites_store.dart';
import 'package:crypto_exercice/view/crypto_list_screen.dart';
import 'package:crypto_exercice/view/login_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Crypto App',
      home: AuthGate(), // ← was CryptoListScreen()
    );
  }
}

/// Decides: logged out → LoginView, logged in → the app.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: AuthService().authStateChanges(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final user = snap.data;
        if (user == null) return const LoginView();

        return SignedInShell(
          key: ValueKey(user.uid), // different user → brand new controller
          user: user,
        );
      },
    );
  }
}

/// Owns ONE controller for the signed-in user and disposes it on logout.
class SignedInShell extends StatefulWidget {
  const SignedInShell({super.key, required this.user});
  final User user;

  @override
  State<SignedInShell> createState() => _SignedInShellState();
}

class _SignedInShellState extends State<SignedInShell> {
  late final CryptoController controller = CryptoController()
    ..attachFavorites(FirestoreFavoritesStore(widget.user.uid));

  @override
  void dispose() {
    controller.dispose(); // cancels the Firestore listener
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      CryptoListScreen(controller: controller);
}