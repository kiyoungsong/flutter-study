import "package:flutter/material.dart";
import "package:geolocator/geolocator.dart";
import "package:google_maps_flutter/google_maps_flutter.dart";

class HomeScreen extends StatelessWidget {
  // 지도 초기화 위치
  static final LatLng companyLatLen = LatLng(37.2933, 127.0705);
  static final Marker marker =
      Marker(markerId: MarkerId("company"), position: companyLatLen);
  static final Circle circle = Circle(
    circleId: CircleId("choolCheckCircle"),
    center: companyLatLen,
    fillColor: Colors.blue.withOpacity(0.5),
    radius: 100,
    strokeColor: Colors.blue,
    strokeWidth: 1,
  );
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: renderAppBar(),
      body: FutureBuilder<String>(
        future: checkPermission(),
        builder: (context, snapshot) {
          if (!snapshot.hasData &&
              snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.data == "위치 권한이 허가 되었습니다.") {
            return (Column(children: [
              Expanded(
                  flex: 2,
                  child: GoogleMap(
                    initialCameraPosition:
                        CameraPosition(target: companyLatLen, zoom: 16),
                    // 내 위치 지도에 보여주기
                    myLocationEnabled: true,
                    // 마커표시
                    markers: Set.from([marker]),
                    circles: Set.from([circle]),
                  )),
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.timelapse_outlined,
                    color: Colors.blue,
                    size: 50.0,
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        final curPosition =
                            await Geolocator.getCurrentPosition();
                        final distance = Geolocator.distanceBetween(
                            curPosition.latitude,
                            curPosition.longitude,
                            companyLatLen.latitude,
                            companyLatLen.longitude);

                        bool canCheck = distance < 100;
                        showDialog(
                            context: context,
                            builder: (_) {
                              return AlertDialog(
                                title: Text("출근하기"),
                                content: Text(canCheck
                                    ? "출근을 하시겠습니까?"
                                    : "출근할 수 없는 위치입니다."),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(false);
                                      },
                                      child: Text("취소")),
                                  if (canCheck)
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(true);
                                        },
                                        child: Text("출근하기"))
                                ],
                              );
                            });
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0))),
                      child: const Text(
                        "출근하기!",
                        style: TextStyle(color: Colors.white),
                      ))
                ],
              ))
            ]));
          }

          return Center(
            child: Text(snapshot.data.toString()),
          );
        },
      ),
    );
  }

  AppBar renderAppBar() {
    return AppBar(
      centerTitle: true,
      title: Text("오늘도 출첵",
          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w700)),
      backgroundColor: Colors.white,
    );
  }

  Future<String> checkPermission() async {
    // 위치 서비스 활성화 여부 확인
    final isLocationEnalbed = await Geolocator.isLocationServiceEnabled();

    if (!isLocationEnalbed) {
      return "위치 서비스를 활성화해주세요.";
    }

    // 위치권한 확인
    LocationPermission checkPermission = await Geolocator.checkPermission();

    if (checkPermission == LocationPermission.denied) {
      checkPermission = await Geolocator.requestPermission();
      if (checkPermission == LocationPermission.denied) {
        return "위치 권한을 허가해주세요.";
      }
    }

    if (checkPermission == LocationPermission.deniedForever) {
      return "앱의 위치 권한을 설정에서 허가해주세요.";
    }

    return "위치 권한이 허가 되었습니다.";
  }
}
