import 'dart:io';

import 'package:cafeteria_app/app/data/items.dart';
import 'package:cafeteria_app/widgets/image_source_sheet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ItemDrawter extends StatefulWidget {
  final Function() updateCallback;

  const ItemDrawter({
    super.key,
    required this.title,
    required this.currentItem,
    required this.isNewItem,
    required this.collectionCategory,
    required this.updateCallback,
  }
  );

  final String title;
  final Item currentItem;
  final bool isNewItem;
  final CollectionReference<Map<String, dynamic>> collectionCategory;

  @override
  // ignore: no_logic_in_create_state
  State<ItemDrawter> createState() => _ItemDrawterState(selectedCategoryId: currentItem.categoryId!, imgItemUrlFire: currentItem.imgItem!);
}

class _ItemDrawterState extends State<ItemDrawter> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  var isLoading = false; 

  _ItemDrawterState({
    required this.selectedCategoryId,
    required this.imgItemUrlFire,
  });

  String imgItemUrlFire;
  String selectedCategoryId;
  File? _imageFile;


  @override
  void initState() {
    _nameController.text = widget.currentItem.nameItem!;
    _descriptionController.text = widget.currentItem.descriptionItem!;
    _priceController.text = widget.currentItem.priceItem.toString();
    super.initState();
  }
  

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.5,
      child: Drawer(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      IconButton(
                        onPressed: (){
                          Navigator.of(context).pop();
                        }, 
                        icon: const Icon(Icons.cancel),
                      ),
                      Text(
                        widget.title,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Nombre del Producto'),
                    validator: (value) {
                      // Basic validation
                      if (value?.isEmpty ?? false) {
                        return "please enter item name";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(labelText: 'Descripción'),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _priceController,
                    decoration: const InputDecoration(labelText: 'Precio'),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20),
              
                  widget.isNewItem 
                  ? const SizedBox()
                  : FutureBuilder<QuerySnapshot>(
                    future: widget.collectionCategory.get(),
                    builder: (context, snapshot) {
                      if(snapshot.connectionState == ConnectionState.waiting){
                        return const SizedBox(child: Text('Cargando...'));
                      }else{
                        if(snapshot.hasData && snapshot.data!.docs.isNotEmpty){
                          final categories = snapshot.data!.docs;
                          final categoriesList = categories.map<DropdownMenuItem<String>>((
                            DocumentSnapshot category) {
                              return DropdownMenuItem<String>(
                                value: category.id,
                                child: Text(category['name_category']),
                              );
                            }
                          ).toList();

                          return DropdownButtonFormField<String>(
                            //decoration: const InputDecoration(labelText: 'Categoría'),
                            items: categoriesList,
                            value: selectedCategoryId,
                            onChanged: (value) {
                              setState(() {
                                selectedCategoryId = value!;
                              });
                            },
                          );
                        }else{
                          return const Center(
                            child: Text('No hay categorias disponibles'),
                          );
                        }
                      }
                    }
                  ),

                  const SizedBox(height: 20),
                  
                  Column(
                    children: [
                      //Image
                      ( imgItemUrlFire.isEmpty)
                      ? Container(
                        width: 180,
                        height: 180,
                        margin: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.all(Radius.circular(15))
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.image_not_supported,
                            size: 50,
                            color: Colors.black,
                          ),
                        ),
                      )
                      : Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Image(
                          width: MediaQuery.of(context).size.height * 0.35,
                          image: NetworkImage( imgItemUrlFire ),
                          fit: BoxFit.cover,
                        ),
                      ),
                  
                      // Button to add Image
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          elevation: 4
                        ),
                        onPressed: () async {
                          String imageItemUrl = imgItemUrlFire;
                          
                          // esperar a que se complete la seleccion de la imagen
                          await _getImage(context);

                          //ADD IMAGE to firestore
                          setState(() {
                            isLoading = true;
                          });

                          if(_imageFile != null){

                            imageItemUrl = await uploadFile(
                              file: _imageFile!,
                              path: 'uploads/items_images',
                              refName: '${DateFormat('yyyyMMddHHmmss').format(DateTime.now())}_${widget.currentItem.categoryId!.substring(0,5)}',
                            );
                          }

                          setState(() {
                            imgItemUrlFire = imageItemUrl;
                            isLoading = false;
                          });


                        },
                        child: widget.currentItem.imgItem!.isEmpty 
                        ? const Text('Upload Image')
                        : const Text('Change Image')
                      ),
                    ],
                    
                  ),
              
                  const SizedBox(height: 50),
              
                  Row(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          elevation: 4
                        ),
                        onPressed: () {
                          // Acción al presionar el botón "Cancelar"
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancelar'),
                      ),
                      
                      const SizedBox(width: 30),
                      
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 4
                        ),
                        onPressed: () async {

                          if (_formKey.currentState!.validate()) {

                            setState(() {
                              isLoading = true;
                            });
                
                            var itemCollection = widget.collectionCategory.doc(widget.currentItem.categoryId).collection('items');

                            Item newItem = widget.currentItem;
                            newItem.nameItem = _nameController.text;
                            //newItem.itemId = '';
                            //newItem.categoryId = '';
                            newItem.descriptionItem = _descriptionController.text;
                            newItem.priceItem = double.parse(_priceController.text);
                            newItem.imgItem = imgItemUrlFire;
                            
                
                            if (widget.isNewItem){ // Sí es un nuevo producto
                              await itemCollection.add(
                                newItem.toMap(),
                              );
                            }else{ // Si el producto se va a editar

                              var docReference = itemCollection.doc(widget.currentItem.itemId);

                              // Se compara si se cambió la categoría.
                              var initialCategory = widget.currentItem.categoryId;
                              var currentEditedCategory = selectedCategoryId;
                              
                              if(initialCategory == currentEditedCategory){ // Si es la misa, se sobreescribe en el mismo documento original
                                await docReference.set(
                                  newItem.toMap(),
                                );
                              }else{ // Si cambio, entonces se elimina y se agrega en el nuevo producto.
                                var currentItemsCollectionEdited = widget.collectionCategory.doc(selectedCategoryId).collection('items');

                                //Se agrega a la colleción de categoría seleccionada
                                await currentItemsCollectionEdited.add(
                                  newItem.toMap(),
                                );

                                //Se elimina el documento original.
                                await FirebaseFirestore.instance.runTransaction((transaction) async {
                                  transaction.delete(docReference);
                                });

                              }
                            }
                
                            setState(() {
                              isLoading = false;
                            });
                
                            widget.updateCallback();
                
                            // ignore: use_build_context_synchronously
                            Navigator.of(context).pop();
                            
                          }
                        },
              
                        child: isLoading 
                        ? const CircularProgressIndicator() 
                        : widget.isNewItem ? const Text('Agregar') : const Text('Guardar'),
                        
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _getImage(BuildContext context) async {
    await ImageSourceSheet().getImagefromGallery(
      onImageSelected: (image){
        if(image != null){
          setState(() {
            _imageFile = image;
            print('image changed :D');
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

void showItemDrawer(
  BuildContext context, {
    required String title,
    required Item selecctedItem,
    required CollectionReference<Map<String, dynamic>> collectionRef,
    required bool newItem,
    required Function() updateConfirm,
  }
){
  Navigator.of(context).push(PageRouteBuilder(
    opaque: false,
    pageBuilder: (BuildContext context, _, __) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero
        ).animate(CurvedAnimation(
          parent: _,
          curve: Curves.easeInOut,
        )),
        child: Align(
          alignment: Alignment.centerRight,
          child: FractionallySizedBox(
            widthFactor: MediaQuery.of(context).size.width <= 600 ? 1.0 : 0.5,
            child: Container(
              //width: MediaQuery.of(context).size.width * 0.5, // Adjust the width as needed
              // height: MediaQuery.of(context).size.height, 
              color: const Color.fromARGB(255, 247, 225, 255),
              child: ItemDrawter(
                title: title,
                currentItem: selecctedItem,
                collectionCategory: collectionRef,
                isNewItem: newItem,
                updateCallback: updateConfirm,
              ),
            ),
          ),
        ),
      );
    },
  ));
}