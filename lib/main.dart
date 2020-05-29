import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:country_code_picker/country_localizations.dart';
import 'package:medicad/services/auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      supportedLocales: [
          Locale('en'),
          Locale('it'),
          Locale('fr'),
          Locale('es'),
      ],
      localizationsDelegates: [
        CountryLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AuthService().handleAuth(),
    );
  }
}