import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sketch/colors/primary_swatch.dart';
import 'package:sketch/services/auth.dart';
import 'package:sketch/widgets/button_form_field.dart';
import 'package:sketch/widgets/form_title.dart';
import 'package:sketch/widgets/info_modal.dart';
import 'package:sketch/widgets/my_text_field.dart';
import 'package:sketch/widgets/picture_form_field.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfilSetup extends StatefulWidget {
  const ProfilSetup(
      {Key? key,
      required this.toggleSetup,
      required this.checkExist,
      required this.toggleLoading})
      : super(key: key);

  final Function toggleSetup;
  final Function checkExist;
  final Function toggleLoading;

  @override
  State<ProfilSetup> createState() => _ProfilSetupState();
}

class _ProfilSetupState extends State<ProfilSetup> {
  final _formKey = GlobalKey<FormState>();
  final _firstnameKey = GlobalKey<MyTextFormFieldState>();
  final _lastnameKey = GlobalKey<MyTextFormFieldState>();
  final AuthService _auth = AuthService();
  String? img64;

  void _callbackImage(List<int>? bytes) {
    setState(() {
      FocusScope.of(context).requestFocus(FocusNode());
      img64 = base64Encode(bytes!);
    });
  }

  _validProfil() async {
    if (_formKey.currentState!.validate() && img64 != null) {
      widget.toggleLoading();
      await _auth.updateUserProfil(
          _firstnameKey.currentState!.textController.text,
          _lastnameKey.currentState!.textController.text,
          img64!);
      widget.checkExist();
    } else if (img64 == null) {
      showInfoModal(
          context,
          AppLocalizations.of(context)!.profilSetupErrorModalTitle,
          AppLocalizations.of(context)!.profilSetupErrorModalDescription,
          AppLocalizations.of(context)!.profilSetupErrorModalButton, () {
        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          IconButton(
            padding: const EdgeInsets.all(20.0),
            iconSize: 28.0,
            color: primarySwatch,
            splashRadius: Material.defaultSplashRadius / 2,
            onPressed: () async {
              await _auth.signOut();
            },
            icon: const Icon(Icons.arrow_back),
          ),
          Center(
            child: Column(
              children: [
                const Spacer(flex: 2),
                FormTitle(
                    title: AppLocalizations.of(context)!.profilSetupTitle),
                const Spacer(flex: 1),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.85,
                  height: MediaQuery.of(context).size.height * 0.60,
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      children: [
                        MyTextFormField(
                          key: _lastnameKey,
                          title: AppLocalizations.of(context)!
                              .profilSetupLastnameField,
                          hint: "Ex: Doe",
                          width: double.infinity,
                        ),
                        MyTextFormField(
                          key: _firstnameKey,
                          title: AppLocalizations.of(context)!
                              .profilSetupFirstnameField,
                          hint: "Ex: John",
                          width: double.infinity,
                        ),
                        PictureFormField(
                          title: AppLocalizations.of(context)!
                              .profilSetupPictureField,
                          width: MediaQuery.of(context).size.width * 0.85,
                          callbackImage: _callbackImage,
                        ),
                        ButtonFormField(
                          formKey: _formKey,
                          text: AppLocalizations.of(context)!
                              .profilSetupValidButton,
                          onPressed: _validProfil,
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                          child: Center(
                            child: Text(
                              AppLocalizations.of(context)!
                                  .profilSetupDisclaimer,
                              style: TextStyle(
                                color: primarySwatch.shade900,
                                fontSize: 12.0,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const Spacer(flex: 4),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
