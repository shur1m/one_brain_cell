import 'package:hive/hive.dart';
import 'package:one_brain_cell/utils/sqlHelper.dart';
import 'package:sqflite/sqlite_api.dart';

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
    //if this collection is list, we need to delete
    //everything inside it as well as self from idlist box
    if (isList) {
      Box idListBox = Hive.box('idlists');
      List<int> idList = idListBox.get(collectionName);

      //delete all cards inside from database
      Database db = await SqlHelper.getDatabase('flashcards.db');
      db.execute('DELETE FROM Flashcards WHERE ID IN (${idList.join(', ')})');

      //delete idlists from box
      idListBox.delete(collectionName);
      return;
    }

    while (contents.isNotEmpty) {
      contents.last.delete();
    }
  }
}
