import 'package:flutter/material.dart';
import 'package:sketch/colors/primary_swatch.dart';
import 'package:sketch/services/auth.dart';
import 'package:sketch/widgets/button_form_field.dart';
import 'package:sketch/widgets/email_field.dart';
import 'package:sketch/widgets/info_modal.dart';
import 'package:sketch/widgets/list_modal.dart';
import 'package:sketch/widgets/loading.dart';
import 'package:sketch/widgets/password_confirmation_field.dart';
import 'package:sketch/widgets/password_field.dart';
import 'package:sketch/widgets/form_title.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key, required this.toggleView}) : super(key: key);

  final Function toggleView;

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final _emailKey = GlobalKey<EmailFormFieldState>();
  final _passwordKey = GlobalKey<PasswordFormFieldState>();
  final AuthService _auth = AuthService();
  final List<Widget> _reinitalisationModal = [];
  bool _loading = false;
  bool _valided = false;
  bool _isOpen = false;

  signUp() async {
    if (_formKey.currentState!.validate()) {
      if (!_valided && !_isOpen) {
        _isOpen = true;
        showListModal(
          context,
          AppLocalizations.of(context)!.signUpModalConditionsTitle,
          _reinitalisationModal,
        ).then((value) {
          _isOpen = false;
          _valided = false;
        });
      } else if (_valided) {
        Navigator.pop(context);
        setState(() => _loading = true);
        String email = _emailKey.currentState!.emailController.text;
        dynamic result = await _auth.registerWithEmailPassword(
          _emailKey.currentState!.emailController.text,
          _passwordKey.currentState!.passwordController.text,
        );
        setState(() => _loading = false);
        if (result == null) {
          showInfoModal(
              context,
              AppLocalizations.of(context)!.signUpErrorModalTitle,
              AppLocalizations.of(context)!.signUpErrorModalDescription,
              AppLocalizations.of(context)!.signUpErrorModalButton, () {
            Navigator.pop(context);
          });
          return;
        }
        showInfoModal(
            context,
            AppLocalizations.of(context)!.signUpEmailModalTitle,
            AppLocalizations.of(context)!.signUpEmailModalDescription +
                " " +
                email,
            AppLocalizations.of(context)!.signUpEmailModalButton, () {
          Navigator.pop(context);
          widget.toggleView();
        });
        await _auth.sendVerificationEmail();
        await _auth.signOut();
      }
    }
  }

  Widget _myListView() {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: Scrollbar(
        isAlwaysShown: true,
        trackVisibility: true,
        radius: const Radius.circular(3.0),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: Text(
                AppLocalizations.of(context)!.signUpModalConditionsDescription,
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _reinitalisationModal.clear();
    _reinitalisationModal.add(
      Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 15.0),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.45,
          width: double.infinity,
          child: _myListView(),
        ),
      ),
    );
    _reinitalisationModal.add(
      SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: [
            StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Checkbox(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0)),
                  value: _valided,
                  onChanged: (value) {
                    setState(() {
                      _valided = value!;
                    });
                  },
                );
              },
            ),
            Expanded(
              child: Text(
                AppLocalizations.of(context)!.signUpModalAcceptConditions,
                style: TextStyle(color: primarySwatch.shade600, fontSize: 11.0),
              ),
            ),
          ],
        ),
      ),
    );
    _reinitalisationModal.add(
      Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 20.0),
        child: ElevatedButton(
          style: ButtonStyle(
            fixedSize: MaterialStateProperty.all(
              Size(
                MediaQuery.of(context).size.width * 0.35,
                MediaQuery.of(context).size.height * 0.065,
              ),
            ),
          ),
          onPressed: signUp,
          child: Text(
            AppLocalizations.of(context)!.signUpModalValidButton,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );

    return _loading
        ? const Loading()
        : Scaffold(
            body: Stack(
              children: [
                IconButton(
                  padding: const EdgeInsets.all(20.0),
                  iconSize: 28.0,
                  color: primarySwatch,
                  splashRadius: Material.defaultSplashRadius / 2,
                  onPressed: () {
                    widget.toggleView();
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
                Center(
                  child: Column(
                    children: [
                      const Spacer(flex: 3),
                      FormTitle(
                          title: AppLocalizations.of(context)!.signUpTitle),
                      const Spacer(flex: 2),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.85,
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              EmailFormField(
                                key: _emailKey,
                                title: AppLocalizations.of(context)!
                                    .emailFieldTitle,
                                hint: "john.doe@gmail.com",
                                width: double.infinity,
                              ),
                              PasswordFormField(
                                key: _passwordKey,
                                title:
                                    AppLocalizations.of(context)!.passwordField,
                                hint:
                                    AppLocalizations.of(context)!.passwordField,
                                width: double.infinity,
                              ),
                              PasswordConfirmationFormField(
                                title: AppLocalizations.of(context)!
                                    .passwordConfirmField,
                                hint: AppLocalizations.of(context)!
                                    .passwordConfirmField,
                                width: double.infinity,
                                toConfirmKey: _passwordKey,
                              ),
                              ButtonFormField(
                                formKey: _formKey,
                                text: AppLocalizations.of(context)!
                                    .signUpValidButton,
                                onPressed: signUp,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Spacer(flex: 6),
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}
