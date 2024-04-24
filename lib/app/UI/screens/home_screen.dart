import 'package:cafeteria_app/app/UI/routes/routes.dart';
import 'package:cafeteria_app/app/data/user.dart';
import 'package:cafeteria_app/widgets/icon_text_button.dart';
import 'package:cafeteria_app/widgets/navigation_drawer.dart'
    as widget_navigation_drawer;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLockedButton = true;

  @override
  void initState() {
    super.initState();
    Provider.of<UserProvider>(context, listen: false).getCurrentUser();
    
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Consumer<UserProvider>(
            builder: (context, userProvider, _) {
              return Text(userProvider.currentUser.userStoreName ?? '');
            }),
          leading: IconButton(
            icon: const Icon(Icons.menu), // Icono de hamburguesa
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
          ),
        ),
      
        /// Navigation Drawer
        drawer: const widget_navigation_drawer.NavigationDrawer(),
      
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconTextButton(labelText: 'MENÚ',icon: Icons.restaurant_menu_outlined, 
                          onTap: (){
                            Navigator.of(context).pushNamed(Routes.menu);
                          },
                        ),
                        const SizedBox(width: 16), // Espacio entre botones
                
                        IconTextButton(labelText: 'Pedidos', icon: Icons.receipt_long, 
                          onTap: (){
                            Navigator.of(context).pushNamed(Routes.openTickets);
                          }
                        ),
                      ],
                    ),
                    const SizedBox(height: 16), // Espacio entre filas de botones
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconTextButton(labelText: 'Inventario', icon: Icons.inventory_rounded, 
                          onTap: (){
                            Navigator.of(context).pushNamed(Routes.inventory);
                          }
                        ),
                        const SizedBox(width: 16),
                        IconTextButton(labelText: 'Proovedores', icon: Icons.supervised_user_circle,
                          onTap: (){
                            Navigator.of(context).pushNamed(Routes.contacts);
                          }
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ),
      
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0.0),
                  ),
                ),
                child: isLockedButton ? const Icon(Icons.lock, color: Colors.white,) : const Icon( Icons.lock_open, color: Colors.white),
                onPressed: () {
                  isLockedButton = !isLockedButton;
                  setState(() {}); 
                },
              ),
              ElevatedButton(
                onPressed: isLockedButton 
                ? null 
                : (){
                  //Route<dynamic> route) => false
                  Navigator.of(context).pushNamed(Routes.welcome);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isLockedButton ? const Color.fromARGB(255, 139, 139, 139): const Color.fromARGB(255, 0, 80, 4),
                  foregroundColor: isLockedButton ? Colors.black : Colors.white,
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0.0),
                  ),
                ),
                child: const Text('Finish Day'),
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      ),
    );
  }
}