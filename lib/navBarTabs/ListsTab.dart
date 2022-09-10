import 'package:flutter/material.dart';
import 'package:one_brain_cell/utils/PageCreator.dart';

class ListsTab extends StatefulWidget {
  const ListsTab({Key? key}) : super(key: key);

  @override
  _ListsTabState createState() => _ListsTabState();
}

class _ListsTabState extends State<ListsTab> {
  void _displayList(int i, BuildContext context) {
    //display the view of the list pressed
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ListDisplay(title: "List Number $i")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      //Contains title and list of folders/ lists
      body: SafeArea(
        child: Scrollbar(
            child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: 100,
          itemBuilder: (context, index) {
            if (index == 0) {
              return PageCreator.makeTitle('Flashcard Lists', context);
            }
            int i = index - 1;
            return ListTile(
              leading: i.isEven
                  ? Icon(
                      Icons.list,
                      color: Theme.of(context).iconTheme.color,
                    )
                  : Icon(Icons.folder,
                      color: Theme.of(context).iconTheme.color),
              onTap: () {
                _displayList(i, context);
              },
              title: Text('Tile Number $i',
                  style: Theme.of(context).textTheme.bodyText1),
            );
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
  _ListDisplayState createState() => _ListDisplayState(title);
}

class _ListDisplayState extends State<ListDisplay> {
  late String title;
  _ListDisplayState(String title) {
    this.title = title;
  }

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
