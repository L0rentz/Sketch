import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

Future showListModal(BuildContext context, String title, List<Widget>? list) {
  return showMaterialModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        color: Colors.transparent,
        child: Column(
          children: [
            const Spacer(),
            Container(
              padding: EdgeInsets.fromLTRB(
                MediaQuery.of(context).size.width * 0.07,
                MediaQuery.of(context).size.width * 0.02,
                MediaQuery.of(context).size.width * 0.07,
                MediaQuery.of(context).size.width * 0.05 +
                    MediaQuery.of(context).viewInsets.bottom,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(50.0),
              ),
              child: Wrap(
                alignment: WrapAlignment.center,
                children: [
                  Divider(
                    thickness: 4.0,
                    indent: MediaQuery.of(context).size.width * 0.37,
                    endIndent: MediaQuery.of(context).size.width * 0.37,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Text(
                        title,
                        style: Theme.of(context).textTheme.headline3,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  if (list != null) ...list,
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}
