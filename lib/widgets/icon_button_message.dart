import 'package:flutter/material.dart';

class IconButtonMessage extends StatelessWidget {
  // const ButtonDialogMessage({
  //   super.key,
  //   required this.tittle,
  //   required this.content,
  //   required this.onPressed,
  //   required this.btnContent,
  // });

  const IconButtonMessage({
    super.key,
    this.tittle,
    this.content,
    required this.onPressed,
    required this.icon
  });

  //optios of dialogAlert
  final Widget? tittle;
  final Widget? content;

  //options of button
  final VoidCallback onPressed;
  //you need to add a icon to the button.
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    //you can envolve the text in a card
    return IconButton(
      onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          backgroundColor: Colors.white,
          icon: const Icon(Icons.warning, color: Colors.amber),
          title: tittle,
          content: content,
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancelar'),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                onPressed();
                Navigator.pop(context, 'OK');
              },
              child: const Text('Ok'),
            ),
          ],
        ),
      ),
      icon: icon,
    );
  }
}
