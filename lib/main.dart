import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/language_provider.dart';
import 'package:flutter_complete_guide/providers/meal_provider.dart';
import 'package:flutter_complete_guide/providers/theme_provider.dart';
import 'package:flutter_complete_guide/screens/theme_screen.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './screens/tabs_screen.dart';
import './screens/meal_detail_screen.dart';
import './screens/category_meals_screen.dart';
import './screens/filters_screen.dart';
import './screens/categories_screen.dart';
import 'screens/on_boarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Widget homeScreen =
      (prefs.getBool('watched') ?? false) ? TabsScreen() : OnBoardingScreen();
  // prefs.clear();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<MealProvider>(
          create: (ctx) => MealProvider(),
        ),
        ChangeNotifierProvider<ThemeProvider>(
          create: (ctx) => ThemeProvider(),
        ),
        ChangeNotifierProvider<LanguageProvider>(
          create: (ctx) => LanguageProvider(),
        ),
      ],
      child: MyApp(homeScreen),
    ),
  );
}

class MyApp extends StatelessWidget {
  final Widget mainScreen;
  MyApp(this.mainScreen);
  @override
  Widget build(BuildContext context) {
    var primaryColor =
        Provider.of<ThemeProvider>(context, listen: true).primaryColor;
    var accentColor =
        Provider.of<ThemeProvider>(context, listen: true).accentColor;
    var tm = Provider.of<ThemeProvider>(context, listen: true).tm;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DeliMeals',
      themeMode: tm,
      darkTheme: ThemeData(
        cardColor: Color.fromRGBO(35, 34, 33, 1),
        shadowColor: Colors.white60,
        unselectedWidgetColor: Colors.white70,
        canvasColor: Color.fromRGBO(14, 22, 33, 1),
        splashColor: Colors.white,
        fontFamily: 'Raleway',
        textTheme: ThemeData.dark().textTheme.copyWith(
            bodyText2: TextStyle(
              color: Color.fromRGBO(14, 22, 33, 1),
            ),
            bodyText1: TextStyle(
              color: Colors.white60,
            ),
            headline6: TextStyle(
              color: Colors.white60,
              fontSize: 20,
              fontFamily: 'RobotoCondensed',
              fontWeight: FontWeight.bold,
            )),
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: primaryColor,
        ).copyWith(secondary: Colors.amber).copyWith(secondary: accentColor),
      ),
      theme: ThemeData(
        cardColor: Colors.white,
        shadowColor: Colors.white60,
        canvasColor: Color.fromRGBO(255, 254, 229, 1),
        splashColor: Colors.black,
        fontFamily: 'Raleway',
        textTheme: ThemeData.light().textTheme.copyWith(
            bodyText2: TextStyle(
              color: Color.fromRGBO(20, 50, 50, 1),
            ),
            bodyText1: TextStyle(
              color: Colors.black87,
            ),
            headline6: TextStyle(
              color: Colors.black87,
              fontSize: 20,
              fontFamily: 'RobotoCondensed',
              fontWeight: FontWeight.bold,
            )),
        colorScheme: ColorScheme.fromSwatch(primarySwatch: primaryColor)
            .copyWith(secondary: accentColor),
      ),
      // home: CategoriesScreen(),
      // initialRoute: '/', // default is '/'
      routes: {
        '/': (ctx) => mainScreen,
        CategoryMealsScreen.routeName: (ctx) => CategoryMealsScreen(),
        MealDetailScreen.routeName: (ctx) => MealDetailScreen(),
        FiltersScreen.routeName: (ctx) => FiltersScreen(),
        ThemesScreen.routname: (ctx) => ThemesScreen(),
        TabsScreen.routname: (ctx) => TabsScreen(),
      },

      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (ctx) => CategoriesScreen(),
        );
      },
    );
  }
}
