import 'dart:developer';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_call/const/agora.dart';

class CamScreen extends StatefulWidget {
  const CamScreen({super.key});
  @override
  State<CamScreen> createState() => _CamScreenState();
}

class _CamScreenState extends State<CamScreen> {
  RtcEngine? engine; // 아고라 엔진 저장 변수
  int? uid; // 내 ID
  int? otherUid; // 상대방 ID

  Future<bool> init() async {
    final resp = await [Permission.camera, Permission.microphone].request();
    final cameraPermission = resp[Permission.camera];
    final micPermission = resp[Permission.microphone];

    if (cameraPermission != PermissionStatus.granted ||
        micPermission != PermissionStatus.granted) {
      throw "카메라 또는 마이크 권한이 없습니다.";
    }

    if (engine == null) {
      engine = createAgoraRtcEngine();
      await engine!.initialize(
        const RtcEngineContext(
            appId: APP_ID,
            // 라이브 동영상 송출에 최적화한다.
            channelProfile: ChannelProfileType.channelProfileLiveBroadcasting),
      );

      engine!.registerEventHandler(RtcEngineEventHandler(
          onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
        // 채널 접속성공시 실행
        log("채널에 입장했습니다. uid : ${connection.localUid}");
        setState(() {
          uid = connection.localUid;
        });
      }, onLeaveChannel: (RtcConnection connection, RtcStats stats) {
        log("채널 퇴장");
        setState(() {
          uid = null;
        });
      }, onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
        // 다른 사용자가 접속했을 때 실행
        log("상대가 채널에 입장했습니다. uid: $remoteUid");
        setState(() {
          otherUid = remoteUid;
        });
      }, onUserOffline: (RtcConnection connection, int remoteUid,
              UserOfflineReasonType reason) {
        // 다른 사용자가 채널을 나갔을 때
        log("상대가 채널에서 나갔습니다. uid : $remoteUid");
        setState(() {
          otherUid = null;
        });
      }));

      // 엔진으로 영상을 송출하겠다고 설정합니다.
      await engine!.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
      // 동영상 기능을 활성화
      await engine!.enableVideo();
      // 카메라를 이용해 동영상을 화면에 실행
      await engine!.startPreview();
      await engine!.joinChannel(
        token: TEMP_TOKEN,
        channelId: CHANNEL_NAME,
        // 영상과 관련된 여러 가지 설정
        options: ChannelMediaOptions(), uid: 0,
      );
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("LIVE")),
      body: FutureBuilder(
        future: init(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Center(
                child: Text(
              snapshot.error.toString(),
            ));
          }

          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    renderMainView(),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        color: Colors.grey,
                        height: 160,
                        width: 120,
                        child: renderSubView(),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: ElevatedButton(
                  onPressed: () async {
                    if (engine != null) {
                      await engine!.leaveChannel();
                    }
                    Navigator.of(context).pop();
                  },
                  child: Text("채널 나가기"),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  // 내 핸드폰이 찍는 화면 렌더링
  Widget renderSubView() {
    if (uid != null) {
      return AgoraVideoView(
          controller: VideoViewController(
              rtcEngine: engine!, canvas: const VideoCanvas(uid: 0)));
    } else {
      return CircularProgressIndicator();
    }
  }

  // 상대핸드폰이 찍는 화면 렌더링
  Widget renderMainView() {
    if (otherUid != null) {
      return AgoraVideoView(
          controller: VideoViewController.remote(
              rtcEngine: engine!,
              canvas: VideoCanvas(uid: otherUid),
              connection: const RtcConnection(channelId: CHANNEL_NAME)));
    } else {
      return Center(
        child: Text(
          "다른 사용자가 입장할 때까지 대기해주세요.",
          textAlign: TextAlign.center,
        ),
      );
    }
  }
}
