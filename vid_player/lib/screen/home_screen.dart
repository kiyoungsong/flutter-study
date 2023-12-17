import "package:flutter/material.dart";
import "package:image_picker/image_picker.dart";
import "package:vid_player/component/custom_video_player.dart";

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 동영상 저장 변수
  XFile? video;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: OrientationBuilder(
              builder: (context, orientation) =>
                  video == null ? renderEmpty() : renderVideo()),
        ));
  }

  Widget renderEmpty() {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: getBoxDecoration(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _Logo(
            onTap: onNewVideoPressed,
          ),
          SizedBox(
            height: 30.0,
          ),
          _AppName()
        ],
      ),
    );
  }

  void onNewVideoPressed() async {
    final video = await ImagePicker().pickVideo(source: ImageSource.gallery);

    if (video != null) {
      setState(() {
        this.video = video;
      });
    }
  }

  BoxDecoration getBoxDecoration() {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF2A3A7C),
          Color(0xFF000118),
        ],
      ),
    );
  }

  Widget renderVideo() {
    return Center(
      // video가 null일경우 ! 처리함
      child: CustomVideoPlayer(
          video: video!, onNewVideoPressed: onNewVideoPressed),
    );
  }
}

class _Logo extends StatelessWidget {
  final GestureTapCallback onTap;
  const _Logo({required this.onTap, super.key});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Image.asset(
        "asset/img/logo.png",
      ),
    );
  }
}

class _AppName extends StatelessWidget {
  const _AppName({super.key});

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
        color: Colors.white, fontSize: 30.0, fontWeight: FontWeight.w300);
    return (Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "VIDEO",
          style: textStyle,
        ),
        Text(
          "PLAYER",
          style: textStyle.copyWith(
              // 폰트 두께 변경
              fontWeight: FontWeight.w700),
        )
      ],
    ));
  }
}
