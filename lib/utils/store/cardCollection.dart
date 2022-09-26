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
    _deleteContents(key);
    return super.delete();
  }

  void _deleteContents(int collectionKey) async {
    //if this collection is list, we need to delete
    //everything inside it as well as self from idlist box
    if (isList) {
      Box idListBox = Hive.box('idlists');
      List<int> idList = idListBox.get(collectionKey);

      //delete all cards inside from database
      Database db = await SqlHelper.getDatabase('flashcards.db');
      db.execute('DELETE FROM Flashcards WHERE ID IN (${idList.join(', ')})');

      //delete idlists from box
      idListBox.delete(collectionKey);
      print(collectionKey);
      print(idListBox.toMap());
      print(await db.rawQuery('SELECT * FROM Flashcards'));
      return;
    }

    while (contents.isNotEmpty) {
      contents.last.delete();
    }
  }
}
