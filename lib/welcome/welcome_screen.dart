import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Text(
              'PressPlay to get Started'
            ),
            ElevatedButton(
                onPressed: onPressed,
                child: const Text('Go'))
          ],
        ),
      ),
    );
  }
}
