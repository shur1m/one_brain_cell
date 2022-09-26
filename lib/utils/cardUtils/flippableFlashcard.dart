import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:one_brain_cell/utils/cardUtils/roundedFlashcard.dart';
import 'package:one_brain_cell/utils/store/flashcard.dart';

class FlippableFlashcard extends StatefulWidget {
  FlippableFlashcard({Key? key, required this.card}) : super(key: key);
  late Flashcard card;

  @override
  _FlippableFlashcardState createState() => _FlippableFlashcardState();
}

class _FlippableFlashcardState extends State<FlippableFlashcard> {
  @override
  Widget build(BuildContext context) {
    return FlipCard(
      front: RoundedFlashcard(
          card: widget.card,
          child: Text(
            widget.card.front,
            style: Theme.of(context).textTheme.headline5,
            textAlign: TextAlign.center,
          )),
      back: RoundedFlashcard(
        card: widget.card,
        child: Text(
          widget.card.back,
          style: Theme.of(context).textTheme.headline6,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
