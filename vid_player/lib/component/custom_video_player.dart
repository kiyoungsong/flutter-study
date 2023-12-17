import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vid_player/component/custom_icon_button.dart';
import 'package:video_player/video_player.dart';

class CustomVideoPlayer extends StatefulWidget {
  // 선택한 동영상을 저장할 변수
  final XFile video;
  final GestureTapCallback onNewVideoPressed;
  const CustomVideoPlayer(
      {required this.video, required this.onNewVideoPressed, super.key});

  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  bool showControls = true;
  VideoPlayerController? videoController;

  @override
  // covariant 키워드는 CustomVideoPlayer 클래스의 상속된 값도 허가해둔다.
  void didUpdateWidget(covariant CustomVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.video.path != widget.video.path) {
      initializeController();
    }
  }

  @override
  void initState() {
    super.initState();
    initializeController();
  }

  initializeController() async {
    // StatefulWidget에서 선언된 변수 접근 widget를 사용
    final videoController = VideoPlayerController.file(File(widget.video.path));
    await videoController.initialize();

    // initState가 build시 한번만 실행되기 때문에 listener를 추가해줘 setState()를 발생시켜 build가 추가적으로 실행되도록 함
    videoController.addListener(videoControllerListener);
    setState(() {
      this.videoController = videoController;
    });
  }

  void videoControllerListener() {
    setState(() {});
  }

  @override
  void dispose() {
    videoController?.removeListener(videoControllerListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (videoController == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          showControls = !showControls;
        });
      },
      child: AspectRatio(
        aspectRatio: videoController!.value.aspectRatio,
        child: Stack(
          children: [
            VideoPlayer(videoController!),
            if (showControls)
              Container(
                color: Colors.black.withOpacity(0.5),
              ),
            Positioned(
                bottom: 0,
                right: 0,
                left: 0,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      renderTimeTextFromDuration(
                          videoController!.value.position),
                      // 슬라이더가 남는 공간을 모두 차지하도록 구현
                      Expanded(
                        child: Slider(
                          // 슬라이더가 이동할 때마다 실행할 함수
                          onChanged: (double val) {
                            videoController!
                                .seekTo(Duration(seconds: val.toInt()));
                          },
                          // 동영상 재생 위치를 초 단위로 표현
                          value: videoController!.value.position.inSeconds
                              .toDouble(),
                          min: 0,
                          max: videoController!.value.duration.inSeconds
                              .toDouble(),
                        ),
                      ),
                      renderTimeTextFromDuration(
                          videoController!.value.duration),
                    ],
                  ),
                )),
            if (showControls)
              Align(
                // 오른쪽 위 새 동영상 아이콘 위치
                alignment: Alignment.topRight,
                child: CustomIconButton(
                  onPressed: widget.onNewVideoPressed,
                  iconData: Icons.photo_camera_back,
                ),
              ),
            if (showControls)
              Align(
                // 동영상 재생 관련 아이콘 중앙에 위치
                alignment: Alignment.center,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CustomIconButton(
                          onPressed: onReversePressed,
                          iconData: Icons.rotate_left),
                      CustomIconButton(
                          onPressed: onPlayPressed,
                          iconData: videoController!.value.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow),
                      CustomIconButton(
                          onPressed: onForwardPressed,
                          iconData: Icons.rotate_right)
                    ]),
              )
          ],
        ),
      ),
    );
  }

  Widget renderTimeTextFromDuration(Duration duration) {
    // padLeft 최소길이를 2로두고 2보다 작으면 왼쪽에 0을 붙여주는 작업
    return Text(
        "${duration.inMinutes.toString().padLeft(2, "0")}:${(duration.inSeconds % 60).toString().padLeft(2, "0")}",
        style: TextStyle(color: Colors.white));
  }

  void onReversePressed() {
    final currentPosition = videoController!.value.position;
    Duration position = Duration(); // 0초로 위치 초기화
    if (currentPosition.inSeconds > 3) {
      position = currentPosition - Duration(seconds: 3);
    }
    videoController!.seekTo(position);
  }

  void onForwardPressed() {
    // 동영상 길이
    final maxPosition = videoController!.value.duration;
    final currentPosition = videoController!.value.position;
    Duration position = maxPosition;

    // 동영상 최대 길이에서 3초를 뺀 값보다 현재 위치가 짧을 때만 3초 더하기
    if ((maxPosition - Duration(seconds: 3)).inSeconds >
        currentPosition.inSeconds) {
      position = currentPosition + Duration(seconds: 3);
    }

    videoController!.seekTo(position);
  }

  void onPlayPressed() {
    if (videoController!.value.isPlaying) {
      videoController!.pause();
    } else {
      videoController!.play();
    }
  }
}
