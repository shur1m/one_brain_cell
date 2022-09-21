import 'package:flutter/cupertino.dart';

class AlertDialogueWithTextField extends StatefulWidget {
  late Function(String) doneFunction;
  late String title;
  late String placeHolder;

  AlertDialogueWithTextField(
      {Key? key,
      required this.doneFunction,
      required this.title,
      required this.placeHolder})
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
            padding: EdgeInsets.only(bottom: 10), child: Text(widget.title)),
        content: CupertinoTextField(
          controller: _controller,
          placeholder: widget.placeHolder,
        ),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            onPressed: () {
              setState(() {
                Navigator.pop(context);
              });
            },
            isDefaultAction: false,
            child: const Text('Cancel'),
          ),
          CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context);
                widget.doneFunction(_controller.text);
              },
              isDefaultAction: true,
              child: Text(
                'Done',
              )),
        ]);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
