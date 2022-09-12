import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:one_brain_cell/utils/alertDialogueWithTextField.dart';
import 'package:one_brain_cell/utils/pageCreator.dart';
import 'package:one_brain_cell/utils/store/cardCollection.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ListDisplay extends StatefulWidget {
  const ListDisplay({Key? key, required this.currentCollection})
      : super(key: key);
  final CardCollection currentCollection;

  @override
  _ListDisplayState createState() => _ListDisplayState();
}

class _ListDisplayState extends State<ListDisplay> {
  late CardCollection cur = widget.currentCollection;
  late HiveList branches = cur.contents;
  Box dirBox = Hive.box('dir');

  //display view of folder or list when pressed on
  void _displayList(CardCollection next, BuildContext context) {
    //display the view of the list pressed
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ListDisplay(currentCollection: next)));
  }

  void _displayCreateFolderAlert(BuildContext context) {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => AlertDialogueWithTextField(
              doneFunction: (String text) {
                _createFolder(text);
              },
            ));
  }

  //add folder to root Hivelist and dirbox
  void _createFolder(String title) {
    //add folder to root and update screen
    setState(() {
      CardCollection newFolder = CardCollection(title, false, HiveList(dirBox));
      dirBox.add(newFolder);
      cur.contents.add(newFolder);
      cur.save();

      //print out root contents
      print(cur.contents);
    });
  }

  void _deleteCollection(int i) {
    setState(() {
      branches[i].delete();
    });
  }

  //deal with possibility of both list and folder
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Scrollbar(
            //make this reusable means Function(list, Title, functionwhenpressed)
            child: ReorderableListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: branches.length + 1,
          onReorder: ((oldIndex, newIndex) {
            --oldIndex;
            --newIndex;

            if (newIndex >= branches.length) {
              newIndex = branches.length - 1;
            }

            if (newIndex < 0) {
              newIndex = 0;
            }

            HiveObjectMixin tmp = branches.removeAt(oldIndex);
            branches.insert(newIndex, tmp);
            cur.save();
          }),
          itemBuilder: (context, index) {
            if (index == 0) {
              //Gesture Detector prevents reordering for first index
              return GestureDetector(
                  key: ValueKey(-1),
                  onLongPress: () {},
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                            child: PageCreator.makeTitleWithBack(
                                cur.collectionName, context)),
                        IconButton(
                            onPressed: () => _displayCreateFolderAlert(context),
                            icon: Icon(
                              Icons.add,
                              color: Theme.of(context).secondaryHeaderColor,
                            )),
                      ]));
            }
            int i = index - 1;
            return Dismissible(
                key: ObjectKey(branches[i]),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  _deleteCollection(i);
                },
                background: Scaffold(
                  backgroundColor: Colors.red.shade200,
                  body: Center(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.delete,
                          color: Theme.of(context).scaffoldBackgroundColor),
                      Padding(padding: EdgeInsets.only(right: 14)),
                    ],
                  )),
                ),
                child: ListTile(
                  leading: (branches[i] as CardCollection).isList
                      ? Icon(
                          Icons.list,
                          color: Theme.of(context).iconTheme.color,
                        )
                      : Icon(Icons.folder,
                          color: Theme.of(context).iconTheme.color),
                  onTap: () {
                    _displayList(branches[i] as CardCollection, context);
                  },
                  title: Text(branches[i].toString(),
                      style: Theme.of(context).textTheme.bodyText1),
                ));
          },
        )),
      ),
    );
  }
}
