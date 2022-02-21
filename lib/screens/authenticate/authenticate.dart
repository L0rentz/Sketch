import 'package:flutter/material.dart';
import 'package:sketch/screens/authenticate/sign_in.dart';
import 'package:sketch/screens/authenticate/sign_up.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({Key? key}) : super(key: key);

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool _showSignIn = true;

  void _toggleView() {
    setState(() => _showSignIn = !_showSignIn);
  }

  @override
  Widget build(BuildContext context) {
    if (_showSignIn) {
      return SignIn(toggleView: _toggleView);
    } else {
      return SignUp(toggleView: _toggleView);
    }
  }
}
