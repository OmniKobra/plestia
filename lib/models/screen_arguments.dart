class ScreenArguments extends Object {
  final Object? argument;
  const ScreenArguments({this.argument});
}

class MediaScreenArgs extends ScreenArguments {
  final Object? mediaUrls;
  final Object? currentIndex;
  const MediaScreenArgs({required this.mediaUrls, required this.currentIndex});
}
