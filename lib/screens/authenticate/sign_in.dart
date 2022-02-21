import 'package:flutter/material.dart';
import 'package:sketch/services/auth.dart';
import 'package:sketch/widgets/button_form_field.dart';
import 'package:sketch/widgets/email_field.dart';
import 'package:sketch/widgets/info_modal.dart';
import 'package:sketch/widgets/list_modal.dart';
import 'package:sketch/widgets/loading.dart';
import 'package:sketch/widgets/password_field.dart';
import 'package:sketch/widgets/form_title.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key, required this.toggleView}) : super(key: key);

  final Function toggleView;

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  final _reinitialisationFormKey = GlobalKey<FormState>();
  final _emailKey = GlobalKey<EmailFormFieldState>();
  final _reinitialisationEmailKey = GlobalKey<EmailFormFieldState>();
  final _passwordKey = GlobalKey<PasswordFormFieldState>();
  final AuthService _auth = AuthService();
  final List<Widget> _reinitalisationModal = [];
  bool _loading = false;

  signIn() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _loading = true);
      String email = _emailKey.currentState!.emailController.text;
      dynamic result = await _auth.signInWithEmailPassword(
        email,
        _passwordKey.currentState!.passwordController.text,
      );
      if (result == null) {
        setState(() => _loading = false);
        showInfoModal(
            context,
            AppLocalizations.of(context)!.signInErrorModalTitle,
            AppLocalizations.of(context)!.signInErrorModalDescription,
            AppLocalizations.of(context)!.signInErrorModalButton, () {
          Navigator.pop(context);
        });
        return;
      }
      dynamic user = _auth.myUserFromFirebaseUser(result);
      if (user == null) {
        setState(() => _loading = false);
        showInfoModal(
            context,
            AppLocalizations.of(context)!.signInEmailModalTitle,
            AppLocalizations.of(context)!.signInEmailModalDescription +
                " " +
                email,
            AppLocalizations.of(context)!.signInEmailModalButton, () {
          Navigator.pop(context);
        });
        await _auth.signOut();
      }
    }
  }

  resetPassword() async {
    if (_reinitialisationFormKey.currentState!.validate()) {
      await _auth.sendPasswordReset(
          _reinitialisationEmailKey.currentState!.emailController.text);
      showInfoModal(
          context,
          AppLocalizations.of(context)!.signInEmailModalTitle,
          AppLocalizations.of(context)!.signInEmailReinitialisation,
          AppLocalizations.of(context)!.signInEmailModalButton, () {
        Navigator.pop(context);
        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _reinitalisationModal.clear();
    _reinitalisationModal.add(
      Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 30.0),
        child: Text(
          AppLocalizations.of(context)!.signInEmailReinitialisationSubtitle,
          style: Theme.of(context).textTheme.subtitle2,
          textAlign: TextAlign.center,
        ),
      ),
    );
    _reinitalisationModal.add(
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.30,
        child: Form(
          key: _reinitialisationFormKey,
          child: Column(
            children: [
              EmailFormField(
                key: _reinitialisationEmailKey,
                title: AppLocalizations.of(context)!.emailFieldTitle,
                hint: "john.doe@gmail.com",
                width: double.infinity,
              ),
              ButtonFormField(
                formKey: _reinitialisationFormKey,
                text: AppLocalizations.of(context)!.signInReinitialisation,
                onPressed: resetPassword,
              ),
            ],
          ),
        ),
      ),
    );

    return _loading
        ? const Loading()
        : Scaffold(
            body: Center(
              child: Column(
                children: [
                  const Spacer(flex: 3),
                  FormTitle(title: AppLocalizations.of(context)!.signInTitle),
                  const Spacer(flex: 2),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          EmailFormField(
                            key: _emailKey,
                            title:
                                AppLocalizations.of(context)!.emailFieldTitle,
                            hint: "john.doe@gmail.com",
                            width: double.infinity,
                          ),
                          PasswordFormField(
                            key: _passwordKey,
                            title: AppLocalizations.of(context)!.passwordField,
                            hint: AppLocalizations.of(context)!.passwordField,
                            width: double.infinity,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                AppLocalizations.of(context)!
                                    .signInPasswordForgot,
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                              const SizedBox(width: 5.0),
                              TextButton(
                                onPressed: () {
                                  showListModal(
                                    context,
                                    AppLocalizations.of(context)!
                                        .signInModalReinitialisationDescription,
                                    _reinitalisationModal,
                                  );
                                },
                                child: Text(
                                  AppLocalizations.of(context)!
                                      .signInReinitialisation,
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                              ),
                            ],
                          ),
                          ButtonFormField(
                            formKey: _formKey,
                            text:
                                AppLocalizations.of(context)!.signInValidButton,
                            onPressed: signIn,
                          ),
                          Divider(
                            thickness: 1.0,
                            indent: MediaQuery.of(context).size.width * 0.36,
                            endIndent: MediaQuery.of(context).size.width * 0.36,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.signInNoAccount1,
                                style: Theme.of(context).textTheme.subtitle2,
                              ),
                              const SizedBox(width: 5.0),
                              TextButton(
                                onPressed: () {
                                  widget.toggleView();
                                },
                                child: Text(
                                  AppLocalizations.of(context)!
                                      .signInNoAccount2,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(flex: 6),
                ],
              ),
            ),
          );
  }
}
