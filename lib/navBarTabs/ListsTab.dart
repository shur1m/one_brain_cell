import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:one_brain_cell/utils/alertDialogueWithTextField.dart';
import 'package:one_brain_cell/utils/pageCreator.dart';
import 'package:one_brain_cell/utils/store/cardCollection.dart';

class ListsTab extends StatefulWidget {
  const ListsTab({Key? key}) : super(key: key);

  @override
  _ListsTabState createState() => _ListsTabState();
}

class _ListsTabState extends State<ListsTab> {
  Box dirBox = Hive.box('dir');
  late HiveList branches;
  late CardCollection root;

  @override
  void initState() {
    super.initState();
    if (!dirBox.containsKey(0)) {
      dirBox.put(0, CardCollection("root", false, HiveList(dirBox)));
    }
    root = dirBox.get(0);
    branches = root.contents;
  }

  //display view of folder or list when pressed on
  void _displayList(CardCollection cur, BuildContext context) {
    //display the view of the list pressed
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ListDisplay(title: cur.collectionName)));
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
      root.contents.add(newFolder);
      root.save();

      //print out root contents
      print(root.contents);
    });
  }

  void _deleteCollection(int i) {
    setState(() {
      branches.removeAt(i);
      root.save();
    });
  }

  @override
  Widget build(BuildContext context) {
    //if no root folder, add it
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      //Contains title and list of branches/ lists
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
            root.save();
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
                        PageCreator.makeTitle('Flashcard Lists', context),
                        Expanded(child: Container()),
                        Padding(
                            padding: EdgeInsets.only(right: 10, bottom: 11),
                            child: IconButton(
                                onPressed: () =>
                                    _displayCreateFolderAlert(context),
                                icon: Icon(
                                  Icons.add,
                                  color: Theme.of(context).secondaryHeaderColor,
                                ))),
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

class ListDisplay extends StatefulWidget {
  ListDisplay({Key? key, required this.title}) : super(key: key);
  String title;

  @override
  _ListDisplayState createState() => _ListDisplayState();
}

class _ListDisplayState extends State<ListDisplay> {
  late String title = widget.title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Scrollbar(child: PageCreator.makeTitleWithBack(title, context)),
      ),
    );
  }
}
