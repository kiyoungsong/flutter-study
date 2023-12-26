class StickerModel {
  final String id;
  final String imgPath;

  const StickerModel({required this.id, required this.imgPath});

  @override
  // == 로 하나의 인스턴스가 다른 인스턴스와 같은지 비교할 때 사용되는 로직
  bool operator ==(Object other) {
    return (other as StickerModel).id == id;
  }

  @override
  // Set에서 중복 여부를 결정하는 속성
  int get hashCode => id.hashCode;
}
