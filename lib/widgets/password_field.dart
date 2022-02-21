import 'package:flutter/material.dart';
import 'package:sketch/colors/primary_swatch.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PasswordFormField extends StatefulWidget {
  const PasswordFormField(
      {Key? key, required this.hint, required this.width, required this.title})
      : super(key: key);

  final String hint;
  final String title;
  final double width;

  @override
  State<PasswordFormField> createState() => PasswordFormFieldState();
}

class PasswordFormFieldState extends State<PasswordFormField> {
  final TextEditingController passwordController = TextEditingController();
  bool _obscure = true;

  void _toggle() {
    setState(() {
      _obscure = !_obscure;
    });
  }

  bool _validatePassword(String value) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(value);
  }

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
            controller: passwordController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppLocalizations.of(context)!.errorPasswordEmpty;
              } else if (value.length < 6) {
                return AppLocalizations.of(context)!.errorPasswordWeak;
              } /*else if (!_validatePassword(value)) {
                return 'Please enter a valid password';
              }*/
              return null;
            },
            obscureText: _obscure,
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
              suffixIcon: IconButton(
                splashRadius: Material.defaultSplashRadius / 2,
                icon: _obscure
                    ? Icon(
                        Icons.remove_red_eye,
                        color: Theme.of(context).iconTheme.color,
                      )
                    : Icon(
                        Icons.remove_red_eye_outlined,
                        color: Theme.of(context).iconTheme.color,
                      ),
                onPressed: _toggle,
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
