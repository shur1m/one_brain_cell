import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:one_brain_cell/utils/pageCreator.dart';
import 'package:one_brain_cell/utils/store/cardCollection.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class CardListDisplay extends StatefulWidget {
  CardListDisplay({Key? key, required this.currentCollection})
      : super(key: key);

  late CardCollection currentCollection;

  @override
  _CardListDisplayState createState() => _CardListDisplayState();
}

class _CardListDisplayState extends State<CardListDisplay> {
  List<String> reallyLongList =
      List<String>.generate(100, (index) => "list row long name $index");

  Future<dynamic> _showAddFlashcardBottomSheet() {
    return showCupertinoModalBottomSheet(
        animationCurve: Curves.ease,
        duration: const Duration(milliseconds: 200),
        context: context,
        builder: (context) {
          return Scaffold(
              appBar: CupertinoNavigationBar(
                leading: CupertinoButton(
                  padding: EdgeInsets.all(0),
                  child: Text('Cancel', style: TextStyle(color: Colors.grey)),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                trailing: CupertinoButton(
                  child: Text('Done',
                      style: TextStyle(color: Theme.of(context).buttonColor)),
                  padding: EdgeInsets.all(0),
                  onPressed: () {
                    Navigator.pop(context);
                    //this should add entry to list in db
                    //then add rowid to hivelist of CardCollection
                  },
                ),
              ),
              body: Container());
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: Padding(
            padding: EdgeInsets.only(right: 16),
            child: FloatingActionButton(
              elevation: 5,
              highlightElevation: 1,
              backgroundColor: Theme.of(context).secondaryHeaderColor,
              onPressed: _showAddFlashcardBottomSheet,
              child: Icon(Icons.add, color: Colors.white),
            )),
        body: SafeArea(
            child: Scrollbar(
          child: Column(children: [
            Padding(
                padding: EdgeInsets.only(top: 16, left: 16, right: 16),
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
                    padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(reallyLongList[index],
                            style: Theme.of(context).textTheme.bodyText1),
                      );
                    }))
          ]),
        )));
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