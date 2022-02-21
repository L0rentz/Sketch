import 'package:flutter/material.dart';

class FormTitle extends StatelessWidget {
  const FormTitle({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        0.0,
        MediaQuery.of(context).size.height * 0.025,
        0.0,
        MediaQuery.of(context).size.height * 0.01,
      ),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.70,
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline5,
        ),
      ),
    );
  }
}
