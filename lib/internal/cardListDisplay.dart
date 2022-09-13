import 'package:flutter/material.dart';
import 'package:one_brain_cell/utils/store/cardCollection.dart';

class CardListDisplay extends StatefulWidget {
  CardListDisplay({Key? key, required this.currentCollection})
      : super(key: key);

  late CardCollection currentCollection;

  @override
  _CardListDisplayState createState() => _CardListDisplayState();
}

class _CardListDisplayState extends State<CardListDisplay> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(child: Scrollbar(child: Container())));
  }
}
