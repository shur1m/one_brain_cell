import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:one_brain_cell/utils/cardUtils/flippableFlashcard.dart';
import 'package:one_brain_cell/utils/cardUtils/roundedFlashcard.dart';
import 'package:one_brain_cell/utils/pageCreator.dart';
import 'package:one_brain_cell/utils/sqlHelper.dart';

import 'package:one_brain_cell/utils/store/flashcard.dart';
import 'package:sqflite/sqlite_api.dart';

class FlashcardDisplay extends StatefulWidget {
  FlashcardDisplay({Key? key, required this.card, required this.updateCallback})
      : super(key: key);

  late Flashcard card;
  late void Function() updateCallback;

  @override
  _FlashcardDisplayState createState() => _FlashcardDisplayState();
}

class _FlashcardDisplayState extends State<FlashcardDisplay> {
  TextEditingController frontTextController = TextEditingController();
  TextEditingController backTextController = TextEditingController();

  //updates flashcard in database
  void _updateFlashcard(String front, String back) async {
    Database cardDatabase = await SqlHelper.getDatabase('flashcards.db');
    //setstate after updating card object

    await cardDatabase.update(
        'Flashcards',
        {
          'front': front,
          'back': back,
          'status': widget.card.status,
          'collection': widget.card.collection
        },
        where: 'ID = ?',
        whereArgs: [widget.card.rowid],
        conflictAlgorithm: ConflictAlgorithm.replace);

    setState(() {
      widget.card.front = front;
      widget.card.back = back;
    });
  }

  //function to show the editor on press
  void _showAddFlashcardBottomSheet() {
    PageCreator.makeEditFlashcardSheet(
        context, frontTextController, backTextController, () {
      _updateFlashcard(frontTextController.text, backTextController.text);

      //remove text from controller
      frontTextController.clear();
      backTextController.clear();

      widget.updateCallback();

      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Stack(children: [
        Padding(
            padding: EdgeInsets.all(8),
            child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios_new_rounded,
                    color: Theme.of(context).secondaryHeaderColor))),
        Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            FlippableFlashcard(card: widget.card),
            Padding(padding: EdgeInsets.only(bottom: 8)),
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  onPressed: () {
                    _showAddFlashcardBottomSheet();
                  },
                  child: Flexible(
                      child: Row(children: [
                    Padding(
                        padding: EdgeInsets.only(top: 8, bottom: 8, right: 8),
                        child: Icon(Icons.edit_rounded)),
                    Text('edit')
                  ])),
                )
              ],
            ),
          ]),
        )
      ]),
    ));
  }

  @override
  void dispose() {
    frontTextController.dispose();
    backTextController.dispose();
    super.dispose();
  }
}
