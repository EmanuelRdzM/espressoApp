import 'package:cafeteria_app/app/UI/screens/menu_screen/tabs_screen/category_tab.dart';
import 'package:cafeteria_app/app/UI/screens/menu_screen/tabs_screen/items_tab.dart';
import 'package:cafeteria_app/app/UI/screens/menu_screen/tabs_screen/menu_tab.dart';
import 'package:flutter/material.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int currenIndex = 0;
  String _selectedMenuId = '';
  String _selectedCategoryId = '';

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    //_tabController.addListener(() => _handleTabChange() );
  }

  @override
  void didUpdateWidget(covariant MenuScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    _selectedMenuId = '';
  }
  
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: TabBar(
            controller: _tabController,
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
              Tab(text: 'Prodcutos')
            ],
          ),
          leading: IconButton(
            onPressed: (){
              Navigator.of(context).pop();
            }, icon: const Icon(Icons.arrow_back_ios_new),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          //children: _tabs,
          children: [
            MenuTab(
              onMenuSelected: (menuId) {
                setState(() {
                  _selectedMenuId = menuId;
                  _selectedCategoryId = '';
                });
                _onMenuSelected(1);
              },
            ),
            CategoryTab(
              selectedMenuId: _selectedMenuId, 
              updateSelection: (menuId){
                setState(() {
                  _selectedMenuId = menuId;
                  _selectedCategoryId = '';
                });
              },
              onCategorySelected: (categoryId, menuId){
                setState(() {
                  _selectedMenuId = menuId;
                  _selectedCategoryId = categoryId;
                });

                _onMenuSelected(2);
            }),
            ItemTab(
              selectedMenuId: _selectedMenuId,
              selectedCategoryId: _selectedCategoryId,
            ),
          ],
        ),
      ),
    );
  }

  void _onMenuSelected(int index) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _tabController.animateTo(index);
    });
  }

}