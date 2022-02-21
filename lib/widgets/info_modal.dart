import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:sketch/colors/primary_swatch.dart';

showInfoModal(BuildContext context, String title, String text, String button,
    Function onPressed) {
  showMaterialModalBottomSheet(
    enableDrag: false,
    context: context,
    builder: (BuildContext context) {
      return Container(
        color: Colors.transparent,
        child: Column(
          children: [
            const Spacer(flex: 5),
            Container(
              margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.15),
              padding: EdgeInsets.fromLTRB(
                MediaQuery.of(context).size.width * 0.07,
                MediaQuery.of(context).size.width * 0.02,
                MediaQuery.of(context).size.width * 0.07,
                MediaQuery.of(context).size.width * 0.05,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Wrap(
                alignment: WrapAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: Material(
                      shape: const CircleBorder(),
                      child: IconButton(
                        padding: const EdgeInsets.all(0.0),
                        splashRadius: Material.defaultSplashRadius / 2,
                        onPressed: () => onPressed(),
                        icon: Icon(
                          Icons.close,
                          color: primarySwatch.shade200,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headline4,
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 30.0),
                    child: Text(
                      text,
                      style: Theme.of(context).textTheme.subtitle2,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all(
                        Size(
                          MediaQuery.of(context).size.width * 0.35,
                          MediaQuery.of(context).size.height * 0.065,
                        ),
                      ),
                    ),
                    onPressed: () => onPressed(),
                    child: Text(
                      button,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(flex: 3),
          ],
        ),
      );
    },
  );
}
