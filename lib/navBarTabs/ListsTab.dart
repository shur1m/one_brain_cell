import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:one_brain_cell/internal/cardListDisplay.dart';

import 'package:one_brain_cell/utils/alertDialogueWithTextField.dart';
import 'package:one_brain_cell/utils/pageCreator.dart';
import 'package:one_brain_cell/utils/store/cardCollection.dart';

class ListsTab extends StatefulWidget {
  ListsTab({Key? key, CardCollection? this.currentCollection})
      : super(key: key);

  CardCollection? currentCollection;

  @override
  _ListsTabState createState() => _ListsTabState();
}

class _ListsTabState extends State<ListsTab> {
  Box dirBox = Hive.box('dir');

  late HiveList branches;
  late CardCollection root;
  late bool isRootFolder;

  @override
  void initState() {
    super.initState();

    //if this is the top/root folder, we should do these checks
    if (widget.currentCollection == null) {
      isRootFolder = true;
      if (!dirBox.containsKey(0)) {
        dirBox.put(0, CardCollection("root", false, HiveList(dirBox)));
      }
      root = dirBox.get(0);

      //if this is inner folder, just set it to passed value
    } else {
      isRootFolder = false;
      root = widget.currentCollection as CardCollection;
    }

    branches = root.contents;
  }

  Widget _getTitleWidget() {
    if (isRootFolder) {
      return PageCreator.makeTitle('Flashcard Lists', context);
    }

    return PageCreator.makeTitleWithBack(root.collectionName, context);
  }

  //display view of folder or list when pressed on
  void _displayFolder(CardCollection next, BuildContext context) {
    //display the view of the list pressed
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ListsTab(currentCollection: next)));
  }

  void _displayCardList(CardCollection next, BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => CardListDisplay(
              currentCollection: next,
              updateListNameCallback: _updateEntryName,
            )));
  }

  //function to trick setState to update after edit of name
  void _updateEntryName() {
    setState(() {
      root.save();
    });
  }

  void _displayCreateCollectionAlert(BuildContext context, bool isList) {
    showCupertinoDialog<void>(
        context: context,
        builder: (BuildContext context) => AlertDialogueWithTextField(
              title: isList ? 'Create List' : 'Create Folder',
              placeHolder: isList ? 'List Name' : 'Folder Name',
              doneFunction: (String text) {
                _createCollection(text, isList);
              },
            ));
  }

  void _displayCreateActionSheet(BuildContext context) {
    showCupertinoModalPopup<void>(
        context: context,
        builder: ((context) => CupertinoActionSheet(
              actions: [
                CupertinoActionSheetAction(
                    onPressed: () {
                      Navigator.pop(context);
                      _displayCreateCollectionAlert(context, false);
                    },
                    child: Text('Create Folder')),
                CupertinoActionSheetAction(
                    onPressed: () {
                      Navigator.pop(context);
                      _displayCreateCollectionAlert(context, true);
                    },
                    child: Text('Create List'))
              ],
              cancelButton: CupertinoActionSheetAction(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            )));
  }

  //add folder to root Hivelist and dirbox
  void _createCollection(String title, bool isList) {
    //ensure no duplicate names for lists
    if (isList && Hive.box('idlists').containsKey(title)) {
      showCupertinoDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: Text('Choose another Name'),
              content: Text('Flashcard lists cannot have the same name.'),
              actions: [
                CupertinoDialogAction(
                  child: Text('OK'),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            );
          });
      return;
    }

    //add folder to root and update screen
    setState(() {
      CardCollection newCollection = CardCollection(
          title, isList, HiveList(isList ? Hive.box('idlists') : dirBox));
      dirBox.add(newCollection);
      root.contents.add(newCollection);
      root.save();

      //place empty id list into idlists box
      if (isList) {
        Hive.box('idlists').put(title, <int>[]);
      }
    });
  }

  void _deleteCollection(int i) {
    setState(() {
      branches[i].delete();
    });
  }

  @override
  Widget build(BuildContext context) {
    //if no root folder, add it
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      //Contains title and list of branches/ lists
      body: SafeArea(
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Padding(
              padding: EdgeInsets.only(left: 16, top: 8, right: 16),
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                Expanded(child: _getTitleWidget()),
                IconButton(
                    onPressed: () {
                      print('Number of Collections: ${dirBox.length}');
                      return _displayCreateActionSheet(context);
                    },
                    icon: Icon(
                      Icons.add,
                      color: Theme.of(context).secondaryHeaderColor,
                    )),
              ])),
          Expanded(
              //make this reusable means Function(list, Title, functionwhenpressed)
              child: ReorderableListView.builder(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            itemCount: branches.length,
            onReorder: ((oldIndex, newIndex) {
              newIndex = (newIndex > oldIndex) ? newIndex - 1 : newIndex;
              if (newIndex >= branches.length) {
                newIndex = branches.length - 1;
              }

              if (newIndex < 0) {
                newIndex = 0;
              }

              // one zero two
              HiveObjectMixin tmp = branches.removeAt(oldIndex);
              branches.insert(newIndex, tmp);
              root.save();
            }),
            itemBuilder: (context, i) {
              return Dismissible(
                  key: ObjectKey(branches[i]),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    _deleteCollection(i);
                  },
                  background: PageCreator.makeDismissibleBackground(context),
                  child: ListTile(
                    leading: (branches[i] as CardCollection).isList
                        ? Icon(
                            Icons.list,
                            color: Theme.of(context).iconTheme.color,
                          )
                        : Icon(Icons.folder,
                            color: Theme.of(context).iconTheme.color),
                    onTap: () {
                      CardCollection tab = branches[i] as CardCollection;
                      if (!tab.isList) _displayFolder(tab, context);
                      if (tab.isList) _displayCardList(tab, context);
                    },
                    title: Text(branches[i].toString(),
                        style: Theme.of(context).textTheme.bodyText1),
                  ));
            },
          ))
        ]),
      ),
    );
  }
}
