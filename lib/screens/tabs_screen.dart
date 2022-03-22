import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/meal_provider.dart';
import 'package:flutter_complete_guide/providers/theme_provider.dart';
import 'package:provider/provider.dart';

import '../providers/language_provider.dart';
import '../widgets/main_drawer.dart';
import './favorites_screen.dart';
import './categories_screen.dart';

class TabsScreen extends StatefulWidget {
  static const routname = 'TabsScreen';
  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  List<Map<String, Object>> _pages = [];
  int _selectedPageIndex = 0;

  @override
  void initState() {
    Provider.of<MealProvider>(context, listen: false).getData();
    Provider.of<ThemeProvider>(context, listen: false).getThemeMode();
    Provider.of<ThemeProvider>(context, listen: false).getThemeColors();
    Provider.of<LanguageProvider>(context, listen: false).getLan();

    super.initState();
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var lan = Provider.of<LanguageProvider>(context, listen: true);

    _pages = [
      {
        'page': CategoriesScreen(),
        'title': lan.getTexts("categories"),
      },
      {
        'page': FavoritesScreen(),
        'title': lan.getTexts("your_favorites"),
      },
    ];

    return Directionality(
      textDirection: lan.isEn ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text((_pages[_selectedPageIndex]['title']).toString()),
        ),
        drawer: MainDrawer(),
        body: _pages[_selectedPageIndex]['page'] as Widget,
        bottomNavigationBar: BottomNavigationBar(
          onTap: _selectPage,
          backgroundColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: Colors.white,
          selectedItemColor: Theme.of(context).colorScheme.secondary,
          currentIndex: _selectedPageIndex,
          // type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              backgroundColor: Theme.of(context).primaryColor,
              icon: Icon(Icons.category),
              label: lan.getTexts("categories").toString(),
            ),
            BottomNavigationBarItem(
              backgroundColor: Theme.of(context).primaryColor,
              icon: Icon(Icons.star),
              label: lan.getTexts("your_favorites").toString(),
            ),
          ],
        ),
      ),
    );
  }
}
