import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:one_brain_cell/internal/flashcardDisplay.dart';
import 'package:one_brain_cell/utils/alertDialogueWithTextField.dart';
import 'package:sqflite/sqflite.dart';

import 'package:one_brain_cell/utils/sqlHelper.dart';
import 'package:one_brain_cell/utils/pageCreator.dart';
import 'package:one_brain_cell/utils/store/cardCollection.dart';
import 'package:one_brain_cell/utils/store/flashcard.dart';

class CardListDisplay extends StatefulWidget {
  CardListDisplay(
      {Key? key,
      required this.currentCollection,
      required this.updateListNameCallback})
      : super(key: key);

  late CardCollection currentCollection;
  late Function() updateListNameCallback;

  @override
  _CardListDisplayState createState() => _CardListDisplayState();
}

class _CardListDisplayState extends State<CardListDisplay> {
  Box idListBox = Hive.box('idlists');

  late List<int> rowIdList =
      idListBox.get(widget.currentCollection.collectionName);

  late CardCollection curCardList = widget.currentCollection;
  TextEditingController frontTextController = TextEditingController();
  TextEditingController backTextController = TextEditingController();

  //when building the state, all existing cards need to be loaded using futurebuilder
  //then when adding cards, if index within range of cardFrontList, we just load immediately after setstate
  Future<Flashcard> _getCardAtIndex(int rowid) async {
    Database cardDatabase = await SqlHelper.getDatabase('flashcards.db');
    List<Map> cardMapList = await cardDatabase
        .query('Flashcards', where: 'ID = ?', whereArgs: [rowid]);

    Flashcard card = new Flashcard(
        rowid,
        cardMapList[0]['front'],
        cardMapList[0]['back'],
        cardMapList[0]['status'],
        cardMapList[0]['collection']);
    return card;
  }

  void _createFlashcard(String frontText, String backText) async {
    Database cardDatabase = await SqlHelper.getDatabase('flashcards.db');

    int rowid = await cardDatabase.insert(
        'Flashcards',
        {
          'front': frontText,
          'back': backText,
          'status': 0,
          'collection': widget.currentCollection.collectionName
        },
        conflictAlgorithm: ConflictAlgorithm.replace);

    //place list of ids in idlistbox
    List<int> idList = idListBox
        .get(widget.currentCollection.collectionName, defaultValue: <int>[]);
    idList.add(rowid);
    idListBox.put(widget.currentCollection.collectionName, idList);

    //for debugging database
    // print('___ cardListDisplay.dart ___');
    // print(
    //     'Everything in database: ${await cardDatabase.rawQuery('SELECT * FROM Flashcards')}');
    // print(
    //     'all cards in this list: ${idListBox.get(widget.currentCollection.collectionName)}');

    //set state of list because updated
    setState(() {
      rowIdList = idList;
    });
  }

  void _deleteFlashcard(int index) async {
    //delete from idlist, update idlistbox and state
    int deletedRowId = rowIdList[index];
    setState(() {
      rowIdList.removeAt(index);
      idListBox.put(widget.currentCollection.collectionName, rowIdList);
    });

    //delete from database
    Database cardDatabase = await SqlHelper.getDatabase('flashcards.db');
    cardDatabase
        .delete('Flashcards', where: 'ID = ?', whereArgs: [deletedRowId]);
  }

  //show flashcard in new page
  void _displayFlashcard(int rowid) async {
    Database cardDatabase = await SqlHelper.getDatabase('flashcards.db');
    Flashcard card = await _getCardAtIndex(rowid);

    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => FlashcardDisplay(
              card: card,
              updateCallback: _updateCardName,
            )));
  }

  Future<dynamic> _showAddFlashcardBottomSheet() {
    return PageCreator.makeEditFlashcardSheet(
        context, frontTextController, backTextController, () {
      _createFlashcard(frontTextController.text, backTextController.text);

      //remove text from controller
      frontTextController.clear();
      backTextController.clear();

      Navigator.pop(context);
    });
  }

  void _displayEditListNameAlert() {
    showCupertinoDialog<void>(
        context: context,
        builder: (BuildContext context) => AlertDialogueWithTextField(
            doneFunction: _updateListName,
            title: 'Rename List',
            placeHolder: 'New List Name'));
  }

  void _updateListName(String newName) {
    //we need to update both idlist and collection
    idListBox.delete(widget.currentCollection.collectionName);
    idListBox.put(newName, rowIdList);

    setState(() {
      widget.currentCollection.collectionName = newName;
      widget.currentCollection.save();
    });

    widget.updateListNameCallback();
  }

  void _showOptionActionSheet() {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) => CupertinoActionSheet(
              actions: [
                CupertinoActionSheetAction(
                    onPressed: () {
                      Navigator.pop(context);
                      _displayEditListNameAlert();
                    },
                    child: Text('Edit List Name'))
              ],
              cancelButton: CupertinoActionSheetAction(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel')),
            ));
  }

  //callback used to trick card name update after edit
  void _updateCardName() {
    setState(() {
      rowIdList[0] = rowIdList[0];
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
                padding: const EdgeInsets.only(top: 8, left: 16, right: 16),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          child: PageCreator.makeTitleWithBack(
                              widget.currentCollection.collectionName,
                              context)),
                      //this button should allow study and renaming of list
                      IconButton(
                          onPressed: _showOptionActionSheet,
                          icon: Icon(Icons.more_vert,
                              color: Theme.of(context).secondaryHeaderColor)),
                    ])),
            Expanded(
                child: ListView.builder(
                    itemCount: rowIdList.length,
                    padding:
                        const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                    itemBuilder: (context, index) {
                      //loading is just empty container
                      return FutureBuilder(
                          future: _getCardAtIndex(rowIdList[index]),
                          builder: ((context, snapshot) {
                            if (!snapshot.hasData) {
                              return Container();
                            } else {
                              String cardFrontText =
                                  "Error: database returned null";
                              if (snapshot.data != null) {
                                cardFrontText = snapshot.data?.front as String;
                              }
                              return Dismissible(
                                  key: ValueKey(rowIdList[index]),
                                  direction: DismissDirection.endToStart,
                                  onDismissed: (direction) {
                                    _deleteFlashcard(index);
                                  },
                                  background:
                                      PageCreator.makeDismissibleBackground(
                                          context),
                                  child: ListTile(
                                      onTap: () {
                                        _displayFlashcard(rowIdList[index]);
                                      },
                                      leading: Icon(
                                          CupertinoIcons.rectangle_on_rectangle,
                                          color: Theme.of(context)
                                              .secondaryHeaderColor),
                                      title: Text(cardFrontText,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1)));
                            }
                          }));
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
