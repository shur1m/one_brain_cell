import 'package:flutter/material.dart';
import 'package:one_brain_cell/utils/pageCreator.dart';
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
            child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      child: PageCreator.makeTitleWithBack(
                          widget.card.front, context)),
                ])),
      ],
    )));
  }
}
