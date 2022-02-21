import 'package:flutter/material.dart';
import 'package:sketch/colors/primary_swatch.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EmailFormField extends StatefulWidget {
  const EmailFormField({
    Key? key,
    required this.hint,
    required this.width,
    required this.title,
  }) : super(key: key);

  final String hint;
  final String title;
  final double width;

  @override
  State<EmailFormField> createState() => EmailFormFieldState();
}

class EmailFormFieldState extends State<EmailFormField> {
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0.0, 6.0, 0.0, 6.0),
      width: widget.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: Text(
              widget.title,
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          TextFormField(
            controller: emailController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppLocalizations.of(context)!.emailErrorEmpty;
              } else if (!RegExp(
                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                  .hasMatch(value)) {
                return AppLocalizations.of(context)!.emailErrorInvalid;
              }
              return null;
            },
            style: Theme.of(context).textTheme.bodyText2,
            onChanged: (String value) {},
            obscuringCharacter: "*",
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              errorStyle: const TextStyle(height: 1.0),
              filled: true,
              fillColor: primarySwatch.shade50,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(
                  width: 0,
                  style: BorderStyle.none,
                ),
              ),
              hintText: widget.hint,
              hintStyle: Theme.of(context).textTheme.subtitle1,
            ),
          ),
        ],
      ),
    );
  }
}
