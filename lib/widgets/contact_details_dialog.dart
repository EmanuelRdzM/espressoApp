import 'dart:io';

import 'package:cafeteria_app/app/constants/constants.dart';
import 'package:cafeteria_app/widgets/image_source_sheet.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ContactDetailsDialog extends StatefulWidget {
  final String idSupplier;

  const ContactDetailsDialog({Key? key, required this.idSupplier}) : super(key: key);

  @override
  State<ContactDetailsDialog> createState() => _ContactDetailsDialogState();
}

class _ContactDetailsDialogState extends State<ContactDetailsDialog> {
  bool isUpdatingImage = false;
  
  File? _imageFile;
  
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey[200],
      contentPadding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      content: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('contacts').doc(widget.idSupplier).get(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox(
              child: Text('Cargando...', textAlign: TextAlign.center),
            );
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (!snapshot.hasData || snapshot.data == null || !snapshot.data!.exists) {
            return const Text('Contacto no encontrado');
          }

          // Obtener los datos del contacto
          final Map<String, dynamic> contactData = snapshot.data!.data() as Map<String, dynamic>;
          final String contactName = contactData['provider'] ?? 'Nombre no encontrado';
          final String phoneNumber = contactData['phone'] ?? 'Número de teléfono no encontrado';
          String imageUrlSupplier = contactData['img_supplier'] ?? '';

          return SingleChildScrollView(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.54,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    contactName,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    phoneNumber,
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () async{
                      String ImageContactUrl = imageUrlSupplier;

                      await _getImage(context);

                      setState(() {
                        isUpdatingImage = true;
                      });

                      if(_imageFile != null){
                        ImageContactUrl = await uploadFile(
                          file: _imageFile!,
                          path: 'uploads/contacts_suppliers',
                          refName: '${widget.idSupplier}_'
                        );
                      }

                      await FirebaseFirestore.instance.collection('contacts').doc(widget.idSupplier).update({
                        'img_supplier': ImageContactUrl,
                      });

                      setState(() {
                        imageUrlSupplier = ImageContactUrl;
                        isUpdatingImage = false;
                      });

                    },
                    child: Container(
                      width: MediaQuery.of(context).orientation == Orientation.portrait
                        ? MediaQuery.of(context).size.width * 0.35
                        : MediaQuery.of(context).size.height * 0.4,
                      height: MediaQuery.of(context).orientation == Orientation.portrait
                        ? MediaQuery.of(context).size.width * 0.35
                        : MediaQuery.of(context).size.height * 0.4,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[300],
                        border: Border.all(color: APP_SURFACE_COLOR, width: 5.0),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: APP_PRIMARY_COLOR_LIGHT, width: 3.0),
                        ),
                        child: ClipOval(
                          child: isUpdatingImage 
                          ? const CircularProgressIndicator() 
                          : imageUrlSupplier.isNotEmpty 
                            ? Image.network(imageUrlSupplier, fit: BoxFit.cover) 
                            : const Icon(Icons.camera_alt, size: 80, color: APP_PRIMARY_COLOR_DARK),
                        )
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Lógica para solicitar
                        },
                        child: Text('Solicitar'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Lógica para llamar
                        },
                        child: Text('Llamar'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _getImage(BuildContext context) async {
    await ImageSourceSheet().getImagefromGallery(
      onImageSelected: (image){
        if(image != null){
          setState(() {
            _imageFile = image;
          });
        }
      }
    );
  }
  
  Future<String> uploadFile({
    required File file,
    required String path,
    required String refName,
  }) async {
    String imageName =
        refName + DateTime.now().millisecondsSinceEpoch.toString();
    // Storage reference
    final storageRef = FirebaseStorage.instance.ref().child('$path/$imageName');
    
    // Upload file
    final UploadTask uploadTask = storageRef.putFile(file);

    final TaskSnapshot snapshot = await uploadTask;
    String url = await snapshot.ref.getDownloadURL();
    // return file link
    return url;
  }

}
