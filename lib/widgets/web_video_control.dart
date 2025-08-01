import 'package:flutter/material.dart';
import 'package:flick_video_player/flick_video_player.dart';

import 'data_manager.dart';

/// Default portrait controls.
class WebVideoControl extends StatelessWidget {
  final bool showFullscreenIcon;
  final double iconSize;
  final DataManager? dataManager;
  final double fontSize;
  final FlickProgressBarSettings? progressBarSettings;
  const WebVideoControl(
      {Key? key,
      this.iconSize = 20,
      this.fontSize = 12,
      this.progressBarSettings,
      this.dataManager,
      required this.showFullscreenIcon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlickShowControlsActionWeb(
      child: Stack(
        children: <Widget>[
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(
                top: 20,
              ),
              child: const FlickAnimatedVolumeLevel(
                decoration: BoxDecoration(
                  color: Colors.black26,
                ),
                textStyle: TextStyle(color: Colors.white, fontSize: 20),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              ),
            ),
          ),
          Positioned.fill(
            child: FlickSeekVideoAction(
              child: Center(
                child: FlickVideoBuffer(
                  child: FlickAutoHideChild(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              dataManager!.skipToPreviousVideo();
                            },
                            child: Icon(
                              Icons.skip_previous,
                              color: dataManager!.hasPreviousVideo()
                                  ? Colors.white
                                  : Colors.white38,
                              size: 35,
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: FlickPlayToggle(size: 50),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              dataManager!.skipToNextVideo();
                            },
                            child: Icon(
                              Icons.skip_next,
                              color: dataManager!.hasNextVideo()
                                  ? Colors.white
                                  : Colors.white38,
                              size: 35,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: FlickAutoHideChild(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    FlickVideoProgressBar(
                      flickProgressBarSettings: progressBarSettings,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          FlickPlayToggle(
                            size: iconSize,
                          ),
                          SizedBox(
                            width: iconSize / 2,
                          ),
                          FlickSoundToggle(
                            size: iconSize,
                          ),
                          SizedBox(
                            width: iconSize / 2,
                          ),
                          Row(
                            children: <Widget>[
                              FlickCurrentPosition(
                                fontSize: fontSize,
                              ),
                              FlickAutoHideChild(
                                child: Text(
                                  ' / ',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: fontSize),
                                ),
                              ),
                              FlickTotalDuration(
                                fontSize: fontSize,
                              ),
                            ],
                          ),
                          Expanded(
                            child: Container(),
                          ),
                          if (showFullscreenIcon)
                            FlickFullScreenToggle(
                              size: iconSize,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
