import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sketch/colors/primary_swatch.dart';
import 'package:sketch/firebase_options.dart';
import 'package:sketch/model/user.dart';
import 'package:sketch/screens/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sketch/services/auth.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  } catch (e) {
    print(e);
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<MyUser?>.value(
      initialData: null,
      value: AuthService().user,
      child: MaterialApp(
        title: 'Sketch',
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''),
          Locale('fr', ''),
        ],
        locale: const Locale('fr', ''),
        theme: ThemeData(
          fontFamily: 'Poppins',
          canvasColor: Colors.transparent,
          scaffoldBackgroundColor: Colors.white,
          primarySwatch: primarySwatch,
          scrollbarTheme: ScrollbarThemeData(
            thumbColor: MaterialStateProperty.all(primarySwatch.shade100),
            trackColor: MaterialStateProperty.all(primarySwatch.shade50),
          ),
          iconTheme: const IconThemeData(
            color: Color.fromRGBO(146, 153, 164, 1.0),
          ),
          textTheme: TextTheme(
            bodyText1: const TextStyle(),
            bodyText2: const TextStyle(fontSize: 13.0),
            subtitle1: TextStyle(fontSize: 13.0, color: primarySwatch.shade400),
            subtitle2: TextStyle(fontSize: 14.0, color: primarySwatch.shade400),
            headline6: const TextStyle(fontSize: 12.0),
            headline5:
                const TextStyle(fontSize: 23.0, fontWeight: FontWeight.bold),
            headline4: TextStyle(
              fontSize: 19.0,
              fontWeight: FontWeight.bold,
              color: primarySwatch.shade900,
            ),
            headline3: TextStyle(
              fontSize: 17.0,
              fontWeight: FontWeight.bold,
              color: primarySwatch.shade900,
            ),
          ),
        ),
        home: const Wrapper(),
      ),
    );
  }
}
