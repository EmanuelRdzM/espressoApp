import 'package:cafeteria_app/widgets/dialog_message.dart';
import 'package:cafeteria_app/widgets/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

void addMenuOption(BuildContext context, CollectionReference<Map<String, dynamic>> colection, String option, Function() callback) {
  TextEditingController addNameController = TextEditingController();
  bool isLoading = false;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text('Agregar $option'),
            content: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: addNameController,
                  decoration: InputDecoration(
                    hintText: 'Nombre del $option',
                    labelText: "Name $option",
                  ),
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: isLoading
                    ? null
                    : () async {
                        if (addNameController.text.isNotEmpty) {
                          setState(() {
                            isLoading = true;
                          });
          
                          await colection.add({
                            'name_$option': addNameController.text,
                          });

                          if (!context.mounted) return;
                          Navigator.of(context).pop();
          
                          setState(() {
                            isLoading = false;
                          });
                        }
                        callback();
                        
                      },
                child: isLoading ? const CircularProgressIndicator() : const Text('Aceptar'),
              ),
            ],
          );
        },
      );
    },
  );
}

// void editNameMenuOption(BuildContext context, DocumentReference<Map<String, dynamic>> doc, String option, Function() callback) {
//   TextEditingController editNameController = TextEditingController();
//   bool isLoading = false;

//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return StatefulBuilder(
//         builder: (context, setState) {
//           return AlertDialog(
//             title: Text('Editar $option'),
//             backgroundColor: Colors.white,
//             content: SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: TextField(
//                   controller: editNameController,
//                   decoration: InputDecoration(
//                     labelText: "Nuevo nombre del $option",
//                     //hintText: actualName,
//                   ),
//                 ),
//               ),
//             ),
//             actions: <Widget>[
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//                 child: const Text('Cancelar'),
//               ),
//               TextButton(
//                 onPressed: isLoading
//                 ? null 
//                 : () async {
//                   if (editNameController.text.isNotEmpty) {

//                     setState(() {
//                       isLoading = true;
//                     });

//                     await doc.set(
//                       <String, dynamic>{
//                         'name_$option': editNameController.text
//                       },
//                     );
                    
//                     if (!context.mounted) return;
//                     Navigator.of(context).pop();

//                     setState(() {
//                       isLoading = false;
//                     });
//                   }
//                   callback();
//                 },
//                 child: isLoading
//                 ? const CircularProgressIndicator() 
//                 : const Text('Aceptar'),
//               ),
//             ],
//           );
//         }
//       );
//     },
//   );
// }

void editNameMenuOption(BuildContext context, DocumentReference<Map<String, dynamic>> doc, String option, Function() callback) {
  TextEditingController editNameController = TextEditingController();
  bool isLoading = false;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text('Editar $option',
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: Colors.white,
            content: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      controller: editNameController,
                      decoration: InputDecoration(
                        labelText: "Nuevo nombre del $option",
                        labelStyle: const TextStyle(
                          color: Colors.grey,
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        )
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'Cancelar',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        TextButton(
                          onPressed: isLoading
                          ? null
                          : () async {
                            if (editNameController.text.isNotEmpty) {
                              setState(() {
                                isLoading = true;
                              });
                    
                              await doc.set(
                                <String, dynamic>{
                                  'name_$option': editNameController.text
                                },
                              );
                    
                              if (!context.mounted) return;
                              Navigator.of(context).pop();
                    
                              setState(() {
                                isLoading = false;
                              });
                            }
                            callback();
                          },

                          child: isLoading
                          ? CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).primaryColor,
                            ),
                            )
                          : Text(
                            'Aceptar',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      );
    },
  );
}


void deleteMenuOption(BuildContext context, DocumentReference<Map<String, dynamic>> document, String option, Function() callback) {
  showDialogMessage(
    context, 
    const Text('¿Seguro que deseas eliminar este elemento?', 
      style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w900,
        fontSize: 25
      ),
    ), 
    Column(
      children: [
        const SizedBox(height: 20),
        Center(
          child: RichText(
            text: 
            const TextSpan(text:'Tenga en consideración que todos los productos y/o categorias dependientes tambien serán eliminados',
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w500,
                fontSize: 20,
              ),
            ),
          ),
        ),
      ],
    ),
    () async {
      try {
        await FirebaseFirestore.instance.runTransaction((transaction) async {
          // Eliminar el documento principal del menú
          final docRef = document;
          transaction.delete(docRef);

          if(option.isNotEmpty){ // Obtener y eliminar todas las subcategorías dentro del menú
            final collectionSnapshot = await docRef.collection(option).get();
            for (final doc in collectionSnapshot.docs) {
              transaction.delete(doc.reference);
            }
          }
          
        });
      } catch (error) {
        // Manejo de errores
        showToast(message: 'Error al eliminar el menú: $error');
      }
      callback();
    } 
  );
}