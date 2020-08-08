import 'package:uuid/uuid.dart';

class Category {
  String uid = Uuid().v1();
  String name;
  String imgUrl;
  bool enabled = true;

  Category({this.name, this.imgUrl, this.enabled});

  Map<String, dynamic> toMap() {
    return {
      'uid': this.uid,
      'name': this.name,
      'imgUrl': this.imgUrl,
      'enabled': this.enabled,
    };
  }

  Category.fromFireBaseSnapshot(Map snapshot)
      : uid = snapshot['uid'],
        name = snapshot['name'] ?? '',
        imgUrl = snapshot['imgUrl'] ?? '',
        enabled = snapshot['enabled'] ?? true;

  @override
  bool operator ==(other) => this.uid == other.uid;

//  @override
//  int get hashCode => uid;
}