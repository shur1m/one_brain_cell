import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:one_brain_cell/utils/store/flashcard.dart';

class RoundedFlashcard extends StatefulWidget {
  RoundedFlashcard({Key? key, required this.card, required this.child})
      : super(key: key);

  late Flashcard card;
  late Widget child;

  @override
  _RoundedFlashcardState createState() => _RoundedFlashcardState();
}

class _RoundedFlashcardState extends State<RoundedFlashcard> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(16),
        ),
        child: SizedBox(
            height: 500,
            child: FractionallySizedBox(
                widthFactor: 0.8,
                heightFactor: 1.0,
                child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Center(
                        child: SingleChildScrollView(child: widget.child))))));
  }
}

//  Center(
//               child: widget.child,
//             )
//0.8 w
//0.6 h