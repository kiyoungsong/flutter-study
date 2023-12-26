import 'dart:io';
import "dart:ui" as ui;
import "dart:typed_data";

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_editor/component/footer.dart';
import 'package:image_editor/component/main_app_bar.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import "package:image_editor/component/sticker_model.dart";
import "package:image_editor/component/emoticon_sticker.dart";
import "package:uuid/uuid.dart";
import "package:flutter/services.dart";

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  XFile? image;
  Set<StickerModel> stickers = {};
  String? selectedId;
  GlobalKey imgKey = GlobalKey(); // 이미지로 전환할 위젯에 입력해줄 키값
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          renderBody(),
          Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: MainAppBar(
                onPickImage: onPickImage,
                onSaveImage: onSaveImage,
                onDeleteItem: onDeleteItem,
              )),
          if (image != null)
            Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Footer(
                  onEmoticonTap: OnEmoticonTap,
                ))
        ],
      ),
    );
  }

  Widget renderBody() {
    if (image != null) {
      // stack 크기의 최대 크기만큼 차지하기
      return RepaintBoundary(
        key: imgKey,
        child: Positioned.fill(
            // 위젯 확대 및 좌우 이동을 가능하게 하는 위젯
            child: InteractiveViewer(
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.file(
                File(image!.path),
                fit: BoxFit.cover,
              ),
              ...stickers.map((sticker) => Center(
                    child: EmoticonSticker(
                      key: ObjectKey(sticker.id),
                      onTransform: () {
                        onTransform(sticker.id);
                      },
                      imgPath: sticker.imgPath,
                      isSelected: selectedId == sticker.id,
                    ),
                  ))
            ],
          ),
        )),
      );
    } else {
      return Center(
        child: TextButton(
          style: TextButton.styleFrom(primary: Colors.grey),
          onPressed: onPickImage,
          child: Text("이미지 선택하기"),
        ),
      );
    }
  }

  void OnEmoticonTap(int index) {
    setState(() {
      stickers = {
        ...stickers,
        StickerModel(
          id: Uuid().v4(),
          imgPath: "asset/img/emoticon_$index.png",
        )
      };
    });
  }

  void onTransform(String id) {
    // 스티커가 변형될 때마다 변형중인 스티커를 현재 스티커로 지정
    setState(() {
      selectedId = id;
    });
  }

  void onPickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      this.image = image;
      stickers = {};
    });
  }

  void onSaveImage() async {
    RenderRepaintBoundary boundary =
        imgKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage();
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();

    await ImageGallerySaver.saveImage(pngBytes);
    // 저장 후 Snackbar 보여주기
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("저장되었습니다.")));
  }

  void onDeleteItem() {
    setState(() {
      stickers = stickers.where((sticker) => sticker.id != selectedId).toSet();
    });
  }
}
