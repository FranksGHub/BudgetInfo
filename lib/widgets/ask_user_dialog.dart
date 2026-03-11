import 'package:flutter/material.dart';

class AskUserDialog extends StatefulWidget {
  final String dialogTitle;
  final String leftButtonText;
  final String rightButtonText;
  final Function(bool) onRightButtonPressed;

  const AskUserDialog({super.key, required this.dialogTitle, required this.leftButtonText, required this.rightButtonText, required this.onRightButtonPressed});

  @override
  State<AskUserDialog> createState() => _AskUserDialogState();
}

class _AskUserDialogState extends State<AskUserDialog> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.dialogTitle), 
      actions: [
        TextButton(onPressed: () { widget.onRightButtonPressed(false); Navigator.pop(context); }, child: Text(widget.leftButtonText)),
        TextButton(onPressed: () { widget.onRightButtonPressed(true); Navigator.pop(context); },  child: Text(widget.rightButtonText)),
      ],
    );
  }
}