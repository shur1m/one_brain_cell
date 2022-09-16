import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:one_brain_cell/utils/cardUtils/flippableFlashcard.dart';
import 'package:one_brain_cell/utils/cardUtils/roundedFlashcard.dart';

import 'package:one_brain_cell/utils/store/flashcard.dart';

class FlashcardDisplay extends StatefulWidget {
  FlashcardDisplay({Key? key, required this.card}) : super(key: key);

  late Flashcard card;

  @override
  _FlashcardDisplayState createState() => _FlashcardDisplayState();
}

class _FlashcardDisplayState extends State<FlashcardDisplay> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Stack(children: [
        Padding(
            padding: EdgeInsets.all(16),
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
                    print('this worked');
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
}
