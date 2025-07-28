// ignore_for_file: use_key_in_widget_constructors, avoid_unnecessary_containers

import 'package:flutter/material.dart';

import 'web_video_control.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:video_player/video_player.dart';
import 'data_manager.dart';

class MyVideoPlayer extends StatefulWidget {
  final String url;
  final bool showFullScreenIcon;
  const MyVideoPlayer(this.url, this.showFullScreenIcon);

  @override
  State<MyVideoPlayer> createState() => _MyVideoPlayerState();
}

class _MyVideoPlayerState extends State<MyVideoPlayer> {
  late FlickManager flickManager;
  late DataManager? dataManager;
  late VideoPlayerController videoPlayerController;

  @override
  void initState() {
    super.initState();
    videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(widget.url));
    flickManager = FlickManager(videoPlayerController: videoPlayerController);
    List<String> urls = [widget.url];
    dataManager = DataManager(flickManager: flickManager, urls: urls);
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: ObjectKey(flickManager),
      onVisibilityChanged: (visibility) {
        if (visibility.visibleFraction == 0 && mounted) {
          flickManager.flickControlManager?.autoPause();
        } else if (visibility.visibleFraction == 1 && mounted) {
          flickManager.flickControlManager?.autoResume();
          flickManager.flickControlManager!.unmute();
        }
      },
      child: Container(
        child: FlickVideoPlayer(
          flickManager: flickManager,
          flickVideoWithControls: FlickVideoWithControls(
            controls: WebVideoControl(
              showFullscreenIcon: widget.showFullScreenIcon,
              dataManager: dataManager!,
              iconSize: 30,
              fontSize: 14,
              progressBarSettings: FlickProgressBarSettings(
                height: 5,
                handleRadius: 5.5,
              ),
            ),
            videoFit: BoxFit.contain,
            // aspectRatioWhenLoading: 4 / 3,
          ),
        ),
      ),
    );
  }
}
