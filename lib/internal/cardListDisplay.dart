import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:one_brain_cell/internal/flashcardDisplay.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:math';

import 'package:one_brain_cell/utils/sqlHelper.dart';
import 'package:one_brain_cell/utils/pageCreator.dart';
import 'package:one_brain_cell/utils/store/cardCollection.dart';
import 'package:one_brain_cell/utils/store/flashcard.dart';

class CardListDisplay extends StatefulWidget {
  CardListDisplay({Key? key, required this.currentCollection})
      : super(key: key);

  late CardCollection currentCollection;

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

    //delete this later
    print('___ cardListDisplay.dart ___');
    print(
        'Everything in database: ${await cardDatabase.rawQuery('SELECT * FROM Flashcards')}');
    print(
        'all cards in this list: ${idListBox.get(widget.currentCollection.collectionName)}');

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

    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => FlashcardDisplay(card: card)));
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
