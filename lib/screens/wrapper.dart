import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sketch/model/user.dart';
import 'package:sketch/screens/authenticate/authenticate.dart';
import 'package:sketch/screens/home/home.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);

    return SafeArea(
      child: user == null ? const Authenticate() : const Home(),
    );
  }
}
