import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:quran_hadith/controller/favorite.dart';
import 'package:quran_hadith/controller/quranAPI.dart';
import 'package:quran_hadith/screens/home_screen.dart';
import 'package:quran_hadith/theme/theme_state.dart';

import 'theme/app_theme.dart';

final quranApi = QuranAPI();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.lazyPut<ThemeState>(() => ThemeState());
  ThemeState.to.getThemeModeFromPreferences();
  runApp(
    MultiProvider(
      providers: [
        Provider(create: (context) => quranApi),
        ChangeNotifierProvider.value(value: OnFavorite()),
      ],
      child: QuranHadith(),
    ),
  );
}

// Audio url: https://cdn.alquran.cloud/media/audio/ayah/ar.alafasy/1
class QuranHadith extends StatefulWidget {
  static List<String> supportedLocales = ['en', 'ar'];

  @override
  _QuranHadithState createState() => _QuranHadithState();
}

class _QuranHadithState extends State<QuranHadith> {
  Locale localeCallback(locale, supportedLocales) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode &&
          supportedLocale.countryCode == locale.countryCode)
        return supportedLocale;
    }
    return supportedLocales.first;
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      localizationsDelegates: [
        // AppLocale.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      localeResolutionCallback: localeCallback,
      supportedLocales:
      QuranHadith.supportedLocales.map((l) => Locale(l, '')).toList(),
      title: 'Qur’ān Hadith',
      darkTheme: darkTheme,
      themeMode: ThemeState.to.themeMode,
      theme: theme,
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
