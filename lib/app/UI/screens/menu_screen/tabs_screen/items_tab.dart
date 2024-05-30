import 'package:cafeteria_app/app/UI/screens/menu_screen/tabs_screen/item_drawter.dart';
import 'package:cafeteria_app/app/data/items.dart';
import 'package:cafeteria_app/app/data/user.dart';
import 'package:cafeteria_app/widgets/add_menu_category.dart';
import 'package:cafeteria_app/widgets/icon_progres_indicator.dart';
import 'package:cafeteria_app/widgets/show_info_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class ItemTab extends StatefulWidget{
  final String? selectedMenuId;
  final String? selectedCategoryId;

  const ItemTab({
    super.key, 
    this.selectedMenuId, 
    this.selectedCategoryId
  });

  @override
  // ignore: no_logic_in_create_state
  State<ItemTab> createState() => _ItemTabState(
    selectedMenuId: selectedMenuId ?? '', 
    selectedCategoryId: selectedCategoryId ?? ''
  );
}

class _ItemTabState extends State<ItemTab> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String selectedMenuId;
  String selectedCategoryId;
  String selectedItem = '';
  bool _showAddButton = false;


  
  _ItemTabState({
    required this.selectedMenuId,
    required this.selectedCategoryId,
  });

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: true);


    if(selectedCategoryId.isNotEmpty){
      _showAddButton = true;
    }

    return Scaffold(
      key: _scaffoldKey,
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
          .collection('Users')
          .doc(userProvider.currentUser.userId)
          .collection('menus')
          .get(), 
        builder: (context, snapshot){
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: IconProgressInidcator());
          } else{
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if(snapshot.hasData && snapshot.data!.docs.isNotEmpty){
              
              final menus = snapshot.data!.docs;
              final menuList = menus
                .map<DropdownMenuItem<String>>((DocumentSnapshot menu) {
                  return DropdownMenuItem<String>(
                    value: menu.id,
                    child: Text(menu['name_menu']),
                  );
                }
              ).toList();

              // Creamos opción vacia para menus
              DropdownMenuItem<String> newMenuItem = const DropdownMenuItem<String>(
                value: '', 
                child: Text('Selecciona menú'),
              );
              menuList.insert(0, newMenuItem);
      
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: DropdownButtonFormField<String>(
                          value: selectedMenuId,
                          hint: const Text('Selecciona un menú'),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedMenuId = newValue!;
                              selectedCategoryId = '';
                            });
                          },
                          items: menuList,
                          icon: const Icon(Icons.arrow_drop_down_circle_outlined),
                          style: const TextStyle(color: Colors.black),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(), // Estilo del borde del campo de entrada
                            contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16), // Espaciado interno del campo de entrada
                          ),
                        ),
                      ),
                        
                      const SizedBox(height: 20),
                        
                      // DropDown de categorias.
                      selectedMenuId.isEmpty 
                      ? const SizedBox()
                      : FutureBuilder<QuerySnapshot>(
                        future: FirebaseFirestore.instance
                            .collection('Users')
                            .doc(userProvider.currentUser.userId)
                            .collection('menus')
                            .doc(selectedMenuId)
                            .collection('categories')
                            .get(), 
                        builder: (context, snapshotCategory) {
                          if (snapshotCategory.connectionState == ConnectionState.waiting) {
                            return const Center(child: IconProgressInidcator());
                          } else{
                            if (snapshotCategory.hasError) {
                              return Center(
                                child: Text('Error: ${snapshotCategory.error}')
                              );
                            } else if(snapshotCategory.hasData && snapshotCategory.data!.docs.isNotEmpty){
                      
                              final categories= snapshotCategory.data!.docs;
                        
                              final categoriesList = categories
                                .map<DropdownMenuItem<String>>((DocumentSnapshot category) {
                                  return DropdownMenuItem<String>(
                                    value: category.id,
                                    child: Text(category['name_category']),
                                  );
                                }
                              ).toList();
                        
                              // Creamos opción vacia para categorias
                              DropdownMenuItem<String> newCategoryItem = const DropdownMenuItem<String>(
                                value: '', 
                                child: Text('Selecciona categoría'),
                              );
                              categoriesList.insert(0, newCategoryItem);
                      
                              return SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 20),
                                      width: MediaQuery.of(context).size.width * 0.9,
                                      child: DropdownButtonFormField<String>(
                                        value: selectedCategoryId,
                                        hint: const Text('Selecciona un menú'),
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            selectedCategoryId = newValue!;
                                          });
                                          if(selectedCategoryId.isNotEmpty){
                                            _showAddButton = true;
                                          }
                                        },
                                        items: categoriesList,
                                        icon: const Icon(Icons.arrow_drop_down_circle_outlined),
                                        style: const TextStyle(color: Colors.black),
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(), // Estilo del borde del campo de entrada
                                          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16), // Espaciado interno del campo de entrada
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                
                                    selectedCategoryId.isEmpty
                                    ? const SizedBox()
                                    : FutureBuilder<QuerySnapshot>(
                                      key: ValueKey<String>(selectedCategoryId),
                                      future: FirebaseFirestore.instance
                                          .collection('Users')
                                          .doc(userProvider.currentUser.userId)
                                          .collection('menus')
                                          .doc(selectedMenuId)
                                          .collection('categories')
                                          .doc(selectedCategoryId).
                                          collection('items')
                                          .get(),
                                      builder: (context, snapshotItems) {

                                        var categoryCollection = FirebaseFirestore.instance
                                        .collection('Users')
                                        .doc(userProvider.currentUser.userId)
                                        .collection('menus')
                                        .doc(selectedMenuId)
                                        .collection('categories');

                                        var itemsColection = categoryCollection.doc(selectedCategoryId).collection('items');
                                        
                                        if (snapshotItems.connectionState == ConnectionState.waiting) {
                                          return const Center(child: IconProgressInidcator());
                                        } else {
                                          if (snapshotItems.hasError) {
                                            return Center(
                                              child: Text('Error: ${snapshotItems.error}')
                                            );
                                          } else if (snapshotItems.hasData && snapshotItems.data!.docs.isNotEmpty) {
                                            return ListView.separated(
                                              shrinkWrap: true, // Esto asegura que el ListView no ocupe más espacio del necesario
                                              itemCount: snapshotItems.data!.docs.length,
                                              separatorBuilder: (context, index) => const SizedBox(height: 4.0), // Espacio entre los elementos de la lista
                                              itemBuilder: (context, index) {
                                                final item = snapshotItems.data!.docs[index];

                                                return Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
                                                  child: Card(
                                                    elevation: 0.8,
                                                    margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
                                                    child: ListTile(
                                                      leading: GestureDetector(
                                                        child: const Icon(Icons.restaurant),
                                                      ),
                                                      trailing: Row(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          IconButton(
                                                            onPressed: () async{

                                                              var docRef = await itemsColection.doc(item.id).get();
                                                              Item currentItem = Item.fromDocument(item.id, selectedCategoryId, docRef.data()! );

                                                              // ignore: use_build_context_synchronously
                                                              showItemDrawer(
                                                                context,
                                                                title: 'Editar Producto',
                                                                selecctedItem: currentItem,
                                                                collectionRef: categoryCollection,
                                                                newItem: false,
                                                                updateConfirm: (){
                                                                  setState(() {
                                                                    
                                                                  });
                                                                }
                                                              );


                                                            }, 
                                                            icon: const Icon(Icons.edit),
                                                          ),
                                                          IconButton(
                                                            onPressed: (){
                                                              _deletItemDialog(userProvider.currentUser.userId!, item.id, (){ setState(() { }); });
                                                            }, 
                                                            icon: const Icon(Icons.delete),
                                                          ),
                                                        ],
                                                      ),
                                                      title: Text(item['name_item']),
                                                      onTap: (){
                                                        showDialog(
                                                          context: context, 
                                                          builder: (BuildContext context) {
                                                            return ShowInfoItem(item: item);
                                                          },
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                            
                                          } else {
                                            return const Center(child: Text('No hay productos disponibles.'));
                                          }
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              );
                            } else{
                              return const Center(
                                child: Text('No hay categorias disponbiles'),
                              );
                            }
                          }
                        }
                      )
                        
                      //
                    ],
                  ),
                ),
              );
            } else {
              return const Center(
                child: Text('No hay menús disponbiles'),
              );
            }
          }
        }
      ),

      floatingActionButton: selectedCategoryId.isEmpty 
      ? null
      : FloatingActionButton(
        backgroundColor: !_showAddButton ? const Color.fromARGB(255, 197, 199, 198) : Colors.pink,
        onPressed: !_showAddButton 
        ? null
        : () {

          var categoryCollection = FirebaseFirestore.instance
          .collection('Users')
          .doc(userProvider.currentUser.userId)
          .collection('menus')
          .doc(selectedMenuId)
          .collection('categories');

          Item emptyItem = Item(
            nameItem: '', 
            itemId: '', 
            categoryId: selectedCategoryId, 
            descriptionItem: '', 
            imgItem: '',
            priceItem: 0
          );

          showItemDrawer(
            context,
            title: 'Agregar Producto',
            selecctedItem: emptyItem,
            collectionRef: categoryCollection,
            newItem: true,
            updateConfirm:() {
              setState(() {
                
              });
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _deletItemDialog(String userId, String itemId, Function() updateCallback ){
    final docReference = FirebaseFirestore.instance
      .collection('Users')
      .doc(userId)
      .collection('menus')
      .doc(selectedMenuId)
      .collection('categories')
      .doc(selectedCategoryId)
      .collection('items')
      .doc(itemId);
    const option = '';

    deleteMenuOption(context, docReference, option, (){
      setState(() {
        updateCallback();
      });
    });
  }

}

