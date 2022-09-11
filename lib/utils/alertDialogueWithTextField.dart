import 'package:flutter/cupertino.dart';

class AlertDialogueWithTextField extends StatefulWidget {
  late Function(String) doneFunction;

  AlertDialogueWithTextField({Key? key, required this.doneFunction})
      : super(key: key);

  @override
  _AlertDialogueWithTextFieldState createState() =>
      _AlertDialogueWithTextFieldState();
}

class _AlertDialogueWithTextFieldState
    extends State<AlertDialogueWithTextField> {
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
        title: Padding(
            padding: EdgeInsets.only(bottom: 10), child: Text('Create Folder')),
        content: CupertinoTextField(
          controller: _controller,
          placeholder: 'Folder Name',
        ),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
              onPressed: () {
                widget.doneFunction(_controller.text);
                Navigator.pop(context);
              },
              isDefaultAction: true,
              child: Text(
                'Done',
              )),
          CupertinoDialogAction(
            onPressed: () {
              setState(() {
                Navigator.pop(context);
              });
            },
            isDefaultAction: false,
            child: const Text('Cancel'),
          )
        ]);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
