import 'package:flutter/material.dart';

import 'models/screen_arguments.dart';
import 'screens/article_screen.dart';
import 'screens/home_screen.dart';
import 'screens/media_screen.dart';

class RouteGenerator {
  static const homeScreen = '/home';
  static const articleScreen = '/article';
  static const mediaScreen = '/media';
  RouteGenerator._();
  static Route<dynamic> generateRoute(RouteSettings settings) {
    const zero = Duration.zero;
    switch (settings.name) {
      case mediaScreen:
        final args = settings.arguments;
        final mediaScreenArgs = args as MediaScreenArgs;
        return PageRouteBuilder(
            transitionDuration: zero,
            pageBuilder: (ctx, dbl, _) => MediaScreen(
                mediaUrls: mediaScreenArgs.mediaUrls,
                currentIndex: mediaScreenArgs.currentIndex));
      case articleScreen:
        return PageRouteBuilder(
            transitionDuration: zero,
            pageBuilder: (ctx, dbl, _) => ArticleScreen(settings.arguments));
      case homeScreen:
        return PageRouteBuilder(
            transitionDuration: zero,
            pageBuilder: (ctx, dbl, _) => const MyHomePage());
      default:
        return PageRouteBuilder(
            transitionDuration: zero,
            pageBuilder: (ctx, dbl, _) => const MyHomePage());
    }
  }
}
