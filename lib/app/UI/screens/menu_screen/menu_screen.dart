import 'package:flutter/material.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int currenIndex = 0;

  final List<Widget> _tabs = [
    /// Tabs Screens
    const Scaffold( body: Center(child: Text('MENU'))),
    const Scaffold(body: Center(child: Text('Categorias'))),
    const Scaffold(body: Center(child: Text('productos'))),
    const Scaffold(body: Center(child: Text('Xtras'))),
  ];
  
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: TabBar(
            indicatorColor: Colors.amber,
            labelColor: const Color.fromRGBO(240, 253, 255, 1),
            dividerColor: Theme.of(context).primaryColor,
            unselectedLabelColor: const Color.fromARGB(255, 61, 0, 33),
            unselectedLabelStyle: const TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.w600),
            labelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
            tabs: const [
              Tab(text: 'Menú'),
              Tab(text: 'Categorias'),
              Tab(text: 'Prodcutos'),
              Tab( text: 'Xtras')
            ],
          ),
          leading: IconButton(
            onPressed: (){
              Navigator.of(context).pop();
            }, icon: const Icon(Icons.arrow_back_ios_new),
          ),
        ),
        body: TabBarView(
          children: _tabs,
        ),
      ),
    );
  }
}