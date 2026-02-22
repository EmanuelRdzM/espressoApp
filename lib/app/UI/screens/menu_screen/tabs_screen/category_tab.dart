import 'package:cafeteria_app/app/constants/constants.dart';
import 'package:cafeteria_app/app/data/user.dart';
import 'package:cafeteria_app/widgets/add_menu_category.dart';
import 'package:cafeteria_app/widgets/icon_progres_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryTab extends StatefulWidget {
  final Function(String, String) onCategorySelected;
  final Function(String) updateSelection;

  
  final String? selectedMenuId;

  const CategoryTab({
    super.key,
    required this.onCategorySelected,
    required this.updateSelection,
    this.selectedMenuId,
    }
  );

  @override
  // ignore: no_logic_in_create_state
  State<CategoryTab> createState() => _CategoryTabState(selectedMenuId: selectedMenuId ?? '');
}

class _CategoryTabState extends State<CategoryTab> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String selectedMenuId;
  bool _showAddButton = false;
  
  _CategoryTabState({required this.selectedMenuId});

  @override
  void initState() {
    super.initState();
    //selectedMenuId = widget.selectedMenuId!;
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: true);
    if(selectedMenuId.isNotEmpty){
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
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: IconProgressInidcator());
          } else {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
              
              final menus = snapshot.data!.docs;
              final menuList = menus
                .map<DropdownMenuItem<String>>((DocumentSnapshot menu) {
                  return DropdownMenuItem<String>(
                    value: menu.id,
                    child: Text(menu['name_menu']),
                  );
                }
              ).toList();

              // Creamos opción vacia para categorias
              DropdownMenuItem<String> newMenuItem = const DropdownMenuItem<String>(
                value: '', 
                child: Text('Selecciona un menú'),
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
                              _showAddButton = true;
                              widget.updateSelection(selectedMenuId);
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
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: IconProgressInidcator());
                          } else {
                            if (snapshot.hasError) {
                              return Center(
                                child: Text('Error: ${snapshot.error}')
                              );
                            } else if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                              return ListView.separated(
                                shrinkWrap: true,
                                separatorBuilder: (context, index) => const SizedBox(height: 5),
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  final category = snapshot.data!.docs[index];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
                                    child: Card(
                                      elevation: 0.8,
                                      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
                                      child: ListTile(
                                        onTap: () {
                                          widget.onCategorySelected(category.id, selectedMenuId);
                                        },
                                        leading: GestureDetector(
                                          child: const Icon(Icons.restaurant_menu),
                                        ),
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            GestureDetector(
                                              child: const Icon(Icons.edit),
                                              onTap: (){
                                                _editNameCategoryDialog(userProvider.currentUser.userId!, selectedMenuId, category.id, () => setState(() {}));
                                              },
                                            ),
                                            const SizedBox(width: 12), // Espacio entre los iconos
                                            GestureDetector(
                                              child: const Icon(Icons.delete),
                                              onTap: () {
                                                _deletCategoryDialog(userProvider.currentUser.userId!, selectedMenuId, category.id, () => setState(() {}));
                                              },
                                            ),
                                          ],
                                        ),
                                          title: Text(category['name_category']),
                                      ),
                                    ),
                                  );
                                },
                              );
                              } else {
                                return const Center(child: Text('No hay categorías disponibles.'));
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return const Center(child: Text('No hay menús disponibles.'));
            }
          }
        },
      ),
      
      floatingActionButton: selectedMenuId.isEmpty 
      ? null 
      : FloatingActionButton(
        backgroundColor: !_showAddButton ? const Color.fromARGB(255, 197, 199, 198) : APP_PRIMARY_COLOR,
        onPressed: !_showAddButton 
        ? null
        : () {
          _showAddCategoryDialog(userProvider.currentUser.userId!, selectedMenuId, () => setState( (){} )  );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddCategoryDialog(String userId, String menuId, Function() callback) async{
    final colection = FirebaseFirestore.instance
      .collection('Users')
      .doc(userId)
      .collection('menus')
      .doc(menuId)
      .collection('categories');
    const option = 'category';

    addMenuOption(context, colection, option, (){
      setState(() {
        callback();
      });
    });
  }

  void _editNameCategoryDialog(String userId, String menuId, String categoryId, Function() callback){
    final documentReference = FirebaseFirestore.instance
      .collection('Users')
      .doc(userId)
      .collection('menus')
      .doc(menuId)
      .collection('categories')
      .doc(categoryId);
    const option = 'category';

    editNameMenuOption(context, documentReference, option, (){
      setState(() {
        callback();
      });
    });
  }

  void _deletCategoryDialog(String userId, String menuId, String categoryId, Function() updateCallback ){
    final docReference = FirebaseFirestore.instance
      .collection('Users')
      .doc(userId)
      .collection('menus')
      .doc(menuId)
      .collection('categories')
      .doc(categoryId);
    const option = 'items';

    deleteMenuOption(context, docReference, option, (){
      setState(() {
        updateCallback();
      });
    });

  }
}