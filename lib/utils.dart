import 'package:flutter/material.dart';

void showMsg(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
}

void showSingleInputDialog({
  required BuildContext context,
  required String title,
  required String hintText,
  TextInputType textInputType = TextInputType.text,
  required Function(String) onSave,
  String positiveBtnText = 'Save',
  String negativeBtnText = 'Close',
}) {
  final controller = TextEditingController();
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Padding(
        padding: const EdgeInsets.all(16),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: (){
            Navigator.pop(context);
          },
          child: Text(negativeBtnText),
        ),
        ElevatedButton(
          onPressed: (){
            if(controller.text.isEmpty) return;

            Navigator.pop(context);
            onSave(controller.text);

          },
          child: Text(positiveBtnText),
        )
      ],
    ),
  );
}
