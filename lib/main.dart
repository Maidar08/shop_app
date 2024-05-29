import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/firebase_options.dart';
import 'package:shop_app/globalKeys.dart';
import 'package:shop_app/home.dart';
import 'package:shop_app/provider/globalProvider.dart';
import 'package:shop_app/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  runApp(
    ChangeNotifierProvider(
      create: (context) => GlobalProvider(),
      child: EasyLocalization(
        supportedLocales: const [Locale('en', 'US'), Locale('mn', 'MN')],
        path: 'assets/translations', // Change the path of the translation files 
        fallbackLocale: Locale('en', 'US'),
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<GlobalProvider>(context).currentUser;

    Widget initialRoute = currentUser != null ? HomePage() : LoginPage();

    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      navigatorKey: GlobalKeys.navigatorKey,
      theme: ThemeData(
        useMaterial3: false,
      ),
      home: SafeArea(
        child: initialRoute,
      ),
    );
  }
}
