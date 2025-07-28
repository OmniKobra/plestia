import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import 'providers/article_provider.dart';
import 'providers/blog_provider.dart';
import 'providers/gallery_provider.dart';
import 'providers/home_provider.dart';
import 'providers/theme_provider.dart';
import 'routes.dart';
import 'screens/splash_screen.dart';

//flutter run -d chrome --web-renderer html
// flutter build web --release --web-renderer html
// firebase deploy --only hosting:shape-me
void main() async {
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyBMU8etzL5Dq-E-da_g6ebeWiH96QYaddQ",
          authDomain: "plestia-akkad.firebaseapp.com",
          projectId: "plestia-akkad",
          storageBucket: "plestia-akkad.appspot.com",
          messagingSenderId: "829943508079",
          appId: "1:829943508079:web:031847792472888df0b19a"));
  initializeDateFormatting();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(
            options: const FirebaseOptions(
                apiKey: "AIzaSyBMU8etzL5Dq-E-da_g6ebeWiH96QYaddQ",
                authDomain: "plestia-akkad.firebaseapp.com",
                projectId: "plestia-akkad",
                storageBucket: "plestia-akkad.appspot.com",
                messagingSenderId: "829943508079",
                appId: "1:829943508079:web:031847792472888df0b19a")),
        builder: (_, ctx) {
          return MultiProvider(
              providers: [
                ChangeNotifierProvider.value(value: ThemeModel(context)),
                ChangeNotifierProvider.value(value: HomeProvider()),
                ChangeNotifierProvider.value(value: ArticleProvider()),
                ChangeNotifierProvider.value(value: GalleryProvider()),
                ChangeNotifierProvider.value(value: BlogProvider()),
              ],
              child: MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'Plestia Alaqad',
                  theme: ThemeData(
                      colorScheme: const ColorScheme(
                          primary: Colors.blue,
                          onPrimary: Colors.blue,
                          secondary: Colors.amber,
                          onSecondary: Colors.amber,
                          surface: Colors.white,
                          onSurface: Colors.white,
                          error: Colors.red,
                          onError: Colors.red,
                          brightness: Brightness.dark,
                          background: Colors.black,
                          onBackground: Colors.black54),
                      useMaterial3: true),
                  home: const SplashScreen(),
                  onGenerateRoute: RouteGenerator.generateRoute));
        });
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices =>
      {PointerDeviceKind.touch, PointerDeviceKind.mouse};
}
