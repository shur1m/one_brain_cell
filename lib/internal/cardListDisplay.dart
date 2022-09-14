import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:path/path.dart' as Path;
import 'package:sqflite/sqflite.dart';

import 'package:one_brain_cell/utils/pageCreator.dart';
import 'package:one_brain_cell/utils/store/cardCollection.dart';

class CardListDisplay extends StatefulWidget {
  CardListDisplay({Key? key, required this.currentCollection})
      : super(key: key);

  late CardCollection currentCollection;

  @override
  _CardListDisplayState createState() => _CardListDisplayState();
}

class _CardListDisplayState extends State<CardListDisplay> {
  Box idListBox = Hive.box('idlists');
  List<String> reallyLongList =
      List<String>.generate(100, (index) => "list row long name $index");

  late CardCollection curCardList = widget.currentCollection;
  TextEditingController frontTextController = TextEditingController();
  TextEditingController backTextController = TextEditingController();

  Future<Database> _getDatabase(String dbName) async {
    String databasesPath = await getDatabasesPath();
    String path = Path.join(databasesPath, dbName);
    Database db = await openDatabase(path, version: 2);
    return db;
  }

  void _createFlashcard(String frontText, String backText) async {
    Database cardDatabase = await _getDatabase('flashcards.db');

    int rowid = await cardDatabase.insert(
        'Flashcards', {'front': frontText, 'back': backText, 'status': 0},
        conflictAlgorithm: ConflictAlgorithm.replace);

    //place list of ids in idlistbox
    List<int> idList = idListBox
        .get(widget.currentCollection.collectionName, defaultValue: <int>[]);
    idList.add(rowid);
    idListBox.put(widget.currentCollection.collectionName, idList);

    print(await cardDatabase.rawQuery('SELECT * FROM Flashcards'));
    print(idListBox.get(widget.currentCollection.collectionName));
  }

  Future<dynamic> _showAddFlashcardBottomSheet() {
    return showCupertinoModalBottomSheet(
        animationCurve: Curves.ease,
        duration: const Duration(milliseconds: 200),
        context: context,
        builder: (context) {
          return Scaffold(
              appBar: CupertinoNavigationBar(
                leading: CupertinoButton(
                  padding: const EdgeInsets.all(0),
                  child: const Text('Cancel',
                      style: TextStyle(color: Colors.grey)),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                trailing: CupertinoButton(
                  child: Text('Done',
                      style: TextStyle(color: Theme.of(context).buttonColor)),
                  padding: const EdgeInsets.all(0),
                  onPressed: () {
                    setState(() {
                      //this should add entry to list in db
                      //then add rowid to hivelist of CardCollection (curcardlist)
                      _createFlashcard(
                          frontTextController.text, backTextController.text);

                      //remove text from controller
                      frontTextController.clear();
                      backTextController.clear();

                      Navigator.pop(context);
                    });
                  },
                ),
              ),
              body: ListView(children: [
                Padding(
                    padding: EdgeInsets.symmetric(vertical: 9, horizontal: 18),
                    child: PageCreator.makeCircularTextField(
                        context: context,
                        controller: frontTextController,
                        placeholder: 'Flashcard Front')),
                Padding(
                    padding: EdgeInsets.symmetric(vertical: 9, horizontal: 18),
                    child: PageCreator.makeCircularTextField(
                        context: context,
                        controller: backTextController,
                        placeholder: 'Flashcard Back'))
              ]));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: Padding(
            padding: const EdgeInsets.only(right: 16),
            child: FloatingActionButton(
              elevation: 5,
              highlightElevation: 1,
              backgroundColor: Theme.of(context).secondaryHeaderColor,
              onPressed: _showAddFlashcardBottomSheet,
              child: const Icon(Icons.add, color: Colors.white),
            )),
        body: SafeArea(
            child: Scrollbar(
          child: Column(children: [
            Padding(
                padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          child: PageCreator.makeTitleWithBack(
                              widget.currentCollection.collectionName,
                              context)),
                    ])),
            Expanded(
                child: ListView.builder(
                    itemCount: reallyLongList.length,
                    padding:
                        const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(reallyLongList[index],
                            style: Theme.of(context).textTheme.bodyText1),
                      );
                    }))
          ]),
        )));
  }

  @override
  void dispose() {
    frontTextController.dispose();
    backTextController.dispose();
    super.dispose();
  }
}

// FutureBuilder(
//       future: slowFuture(),
//       builder: ((context, snapshot) {
//         if (!snapshot.hasData) {
//           return Center(child: CircularProgressIndicator());
//         } else {
//           return Center(child: snapshot.data);
//         }
//       }),
//     )
Future<Widget> slowFuture() async {
  await Future.delayed(Duration(seconds: 1));
  return Text('Loaded!');
}
