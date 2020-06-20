import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medicad/notifiers/music_list.dart';
import 'package:medicad/notifiers/profile_info.dart';
import 'package:medicad/notifiers/videos_list.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:country_code_picker/country_localizations.dart';
import 'package:medicad/screens/dashboard.dart';
import 'package:medicad/notifiers/app_title.dart';
import 'package:medicad/services/auth.dart';

void main() => runApp(
  MultiProvider(
    providers: [
      ChangeNotifierProvider( create: (_) => AppTitleNotifier()),
      ChangeNotifierProvider( create: (_) => MusicListNotifier()),
      ChangeNotifierProvider( create: (_) => VideoListNotifier()),
      ChangeNotifierProvider( create: (_) => ProfileInfoNotifier()),
    ],
    child: MyApp()
  )
);

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
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
      // home: AuthService().handleAuth(),
      home: DashboardScreen()
    );
  }
}