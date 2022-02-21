import 'package:flutter/material.dart';

class ButtonFormField extends StatelessWidget {
  const ButtonFormField({
    Key? key,
    required this.formKey,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  final GlobalKey<FormState> formKey;
  final String text;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 10.0),
      child: ElevatedButton(
        style: ButtonStyle(
          fixedSize: MaterialStateProperty.all(
            Size(
              MediaQuery.of(context).size.width,
              MediaQuery.of(context).size.height * 0.065,
            ),
          ),
        ),
        onPressed: () {
          onPressed();
        },
        child: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
