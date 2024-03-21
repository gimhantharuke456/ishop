import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ishop/controllers/auth_controller.dart';
import 'package:ishop/controllers/voice.controller.dart';
import 'package:ishop/utils/commands.dart';
import 'package:ishop/utils/index.dart';
import 'package:ishop/views/home.view.dart';

class AuthView extends StatefulWidget {
  const AuthView({super.key});

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  Future<void> _authenticateWithBiometrics(BuildContext context) async {
    try {
      final isAuthenticated = await Authentication.authentication();
      if (isAuthenticated) {
        await FirebaseAuth.instance.signInAnonymously();
        context.navigator(context, const HomeView(), shouldAuthenticate: false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Authentication failed')),
        );
      }
    } on PlatformException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.message}')),
      );
    }
  }

  final VoiceController _voiceController = VoiceController();

  @override
  void initState() {
    _voiceController.speek(message: commands["login"] ?? "");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize:
                  const Size(300, 500), // Larger button for easy tapping
              textStyle: const TextStyle(fontSize: 20), // Larger text
            ),
            onPressed: () => _authenticateWithBiometrics(context),
            child: const Text('Login with Fingerprint'),
          ),
        ),
      ),
    );
  }
}
