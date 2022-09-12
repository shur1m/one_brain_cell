import 'package:hive/hive.dart';

part 'cardCollection.g.dart';

@HiveType(typeId: 2)
class CardCollection extends HiveObject {
  @HiveField(0)
  late String collectionName;

  @HiveField(1)
  late bool isList;

  @HiveField(2)
  late HiveList contents;

  CardCollection(this.collectionName, this.isList, this.contents);
  String toString() => collectionName;

  //override delete to delete all folders inside
  @override
  Future<void> delete() {
    //call delete for all children
    _deleteContents();
    return super.delete();
  }

  void _deleteContents() async {
    while (contents.isNotEmpty) {
      if (isList) {
        //to do later (delete keys from listbox)
      } else {
        contents.last.delete();
      }
    }
  }
}
