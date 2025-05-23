import 'package:cafeteria_app/app/UI/routes/routes.dart';
import 'package:cafeteria_app/app/data/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NavigationDrawer extends StatelessWidget{

  const NavigationDrawer({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          _drawerHeader(context),
          const Divider(height: 0),

          ListTile(
            leading: const Icon(Icons.account_circle),
            title: const Text('Perfil'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.attach_money_outlined),
            title: const Text('Historia de Ventas'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.insert_chart_outlined_outlined),
            title: const Text('Estadísticas'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.close),
            title: const Text('Log out'),
            onTap: () {
              Provider.of<UserProvider>(context, listen: false).signOut();
              //FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacementNamed(Routes.login);
            },
          ),
        ],
      ),
    );
  }
}

/// DrawerHeader
Widget _drawerHeader(BuildContext context) {
  return Container(
    color: Theme.of(context).primaryColorDark,
    padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 10),
    child: const Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        /// App logo
        //AppLogo(),
        SizedBox(height: 10),
        Text('APP NAME',
            style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold)),
      ],
    ),
  );
}
