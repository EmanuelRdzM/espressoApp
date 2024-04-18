import 'package:cafeteria_app/app/data/user.dart';
import 'package:cafeteria_app/widgets/add_menu_category.dart';
import 'package:cafeteria_app/widgets/icon_progres_indicator.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class MenuTab extends StatefulWidget {
  final Function(String) onMenuSelected;

  //const MenuTab({super.key});
  const MenuTab({
    super.key,
    required this.onMenuSelected,
  });

  @override
  State<MenuTab> createState() => _MenuTabState();
}

class _MenuTabState extends State<MenuTab> {

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: true);

    return Scaffold(
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
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final menu = snapshot.data!.docs[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
                    child: Card(
                      elevation: 2.0,
                      child: ListTile(
                        onTap: () {
                          widget.onMenuSelected(menu.id);
                        },
                        leading: const Icon(Icons.menu_book),
                        title: Text(menu['name_menu']),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: (){
                                _editNameMenu(userProvider.currentUser.userId!, menu.id, () => setState(() {}));
                              }, 
                              icon: const Icon(Icons.edit)
                            ),
                            //const SizedBox(width: 8), // Espacio entre los iconos
                            IconButton(
                              onPressed: (){
                                _deleteMenu(userProvider.currentUser.userId!, menu.id, (){
                                  setState(() {
                                    
                                  });
                                });
                              }, 
                              icon: const Icon(Icons.delete),
                            ),
                          ],
                        )
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Center(child: Text('No hay menús disponibles.'));
            }
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink,
        onPressed: () {
          _showAddMenuDialog(userProvider.currentUser.userId!, () => setState(() {} ));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddMenuDialog(String userId, Function() callback) async{
    final colection = FirebaseFirestore.instance.collection('Users').doc(userId).collection('menus');
    const option = 'menu';

    addMenuOption(context, colection, option, (){
      setState(() {
        callback();
      });
    });
  }

  void _editNameMenu(String userId, String menuId, Function() callback){
    final documentReference = FirebaseFirestore.instance
      .collection('Users')
      .doc(userId)
      .collection('menus')
      .doc(menuId);
    const option = 'menu';

    editNameMenuOption(context, documentReference, option, (){
      setState(() {
        callback();
      });
    });
  }

  void _deleteMenu(String userId, String menuId, Function() updateCallback ){
    final docReference = FirebaseFirestore.instance.collection('Users').doc(userId).collection('menus').doc(menuId);
    const option = 'categories';

    deleteMenuOption(context, docReference, option, (){
      setState(() {
        updateCallback();
      });
    });

  }
}
