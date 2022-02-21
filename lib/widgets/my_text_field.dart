import 'package:flutter/material.dart';
import 'package:sketch/colors/primary_swatch.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyTextFormField extends StatefulWidget {
  const MyTextFormField({
    Key? key,
    required this.hint,
    required this.width,
    required this.title,
  }) : super(key: key);

  final String hint;
  final String title;
  final double width;

  @override
  State<MyTextFormField> createState() => MyTextFormFieldState();
}

class MyTextFormFieldState extends State<MyTextFormField> {
  final TextEditingController textController = TextEditingController();

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
            controller: textController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppLocalizations.of(context)!.errorEmptyField;
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
