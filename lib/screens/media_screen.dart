// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import 'package:extended_image/extended_image.dart';
import '../widgets/videoplayer.dart';
import '../general.dart';

class MediaScreen extends StatefulWidget {
  final dynamic mediaUrls;
  final dynamic currentIndex;
  const MediaScreen({required this.mediaUrls, required this.currentIndex});

  @override
  State<MediaScreen> createState() => _MediaScreenState();
}

class _MediaScreenState extends State<MediaScreen> {
  final storage = FirebaseStorage.instance;
  int stateindex = 0;
  Widget buildWidget(String url) {
    final reference = storage.refFromURL(url);
    final fullPath = reference.fullPath;
    final type = lookupMimeType(fullPath);
    if (type!.startsWith('image')) {
      return ExtendedImage.network(
        url,
        fit: BoxFit.contain,
        printError: false,
        enableLoadState: true,
        handleLoadingProgress: true,
        initGestureConfigHandler: (_) => GestureConfig(
          inPageView: false,
          initialScale: 1.0,
          cacheGesture: false,
          reverseMousePointerScrollDirection: true,
        ),
      );
    } else {
      return Center(
        child: Container(
          color: Colors.black,
          child: MyVideoPlayer(url, true),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    stateindex = widget.currentIndex;
  }

  @override
  Widget build(BuildContext context) {
    final double deviceHeight = MediaQuery.of(context).size.height;
    final double deviceWidth = MediaQuery.of(context).size.width;
    final lang = General.language(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: SizedBox(
            height: deviceHeight,
            width: deviceWidth,
            child: Stack(
              children: <Widget>[
                Container(
                  color: Colors.black87,
                  child: ExtendedImageGesturePageView.builder(
                    physics: (widget.mediaUrls.length > 1)
                        ? const AlwaysScrollableScrollPhysics()
                        : const NeverScrollableScrollPhysics(),
                    controller: ExtendedPageController(
                        initialPage: widget.currentIndex),
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.mediaUrls.length,
                    onPageChanged: (ind) {
                      setState(() {
                        stateindex = ind;
                      });
                    },
                    itemBuilder: (context, index) {
                      var item = widget.mediaUrls[index];
                      return buildWidget(item);
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    color: Colors.black54,
                    child: Directionality(
                      textDirection:
                          Provider.of<ThemeModel>(context).textDirection,
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 5.0),
                          Text(
                            '${lang.home3} ${stateindex + 1}/${widget.mediaUrls.length}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            )),
      ),
    );
  }
}
