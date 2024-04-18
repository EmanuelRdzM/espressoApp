import 'package:flutter/material.dart';

void showDialogMessage(BuildContext context, Widget tittle, Widget content, Function() buttonAccept) {

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          backgroundColor: Colors.white,
          icon: const Icon(Icons.warning, color: Colors.amber),
          title: tittle,
          content: content,
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                buttonAccept();
                Navigator.of(context).pop();
              },
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }