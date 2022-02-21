import 'dart:io';

import 'package:image_cropper/image_cropper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sketch/colors/primary_swatch.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PictureFormField extends StatefulWidget {
  const PictureFormField(
      {Key? key,
      required this.title,
      required this.width,
      required this.callbackImage})
      : super(key: key);

  final String title;
  final double width;
  final Function callbackImage;

  @override
  State<PictureFormField> createState() => _PictureFormFieldState();
}

enum AppState {
  free,
  picked,
  cropped,
}

class _PictureFormFieldState extends State<PictureFormField> {
  late AppState _state;

  @override
  void initState() {
    super.initState();
    _state = AppState.free;
  }

  final ImagePicker _picker = ImagePicker();
  File? _image;

  _pickImage() async {
    _image = File((await _picker.pickImage(source: ImageSource.gallery))!.path);
    if (_image != null) {
      setState(() {
        _state = AppState.picked;
      });
      await _cropImage();
    }
  }

  Future _cropImage() async {
    File? croppedFile = await ImageCropper().cropImage(
        sourcePath: _image!.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        androidUiSettings: AndroidUiSettings(
          toolbarTitle: AppLocalizations.of(context)!.toolbarPictureFormField,
          activeControlsWidgetColor: Theme.of(context).scaffoldBackgroundColor,
          backgroundColor: Colors.black,
          statusBarColor: Colors.black,
          toolbarColor: Theme.of(context).scaffoldBackgroundColor,
          toolbarWidgetColor: primarySwatch.shade900,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: true,
        ),
        iosUiSettings: const IOSUiSettings());
    if (croppedFile != null) {
      _image = croppedFile;
      setState(() {
        _state = AppState.cropped;
        widget.callbackImage(File(_image!.path).readAsBytesSync());
      });
    } else {
      _clearImage();
    }
  }

  void _clearImage() {
    _image = null;
    setState(() {
      _state = AppState.free;
    });
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
          _state == AppState.cropped
              ? SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        _pickImage();
                      },
                      child: Image.file(
                        _image!,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                )
              : TextButton(
                  style: ButtonStyle(
                    fixedSize: MaterialStateProperty.all(
                      Size(widget.width,
                          MediaQuery.of(context).size.height * 0.13),
                    ),
                    backgroundColor:
                        MaterialStateProperty.all(primarySwatch.shade50),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.cloud_upload_outlined,
                        color: primarySwatch.shade400,
                        size: 30.0,
                      ),
                      Text(AppLocalizations.of(context)!.titlePictureFormField,
                          style: Theme.of(context).textTheme.subtitle1),
                    ],
                  ),
                  onPressed: () {
                    _pickImage();
                  },
                ),
        ],
      ),
    );
  }
}
