import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../dummy_data.dart';
import '../models/category.dart';
import '../models/meal.dart';

class MealProvider extends ChangeNotifier {
  Map<String, bool> filters = {
    'gluten': false,
    'lactose': false,
    'vegan': false,
    'vegetarian': false,
  };
  List<Meal> availableMeals = DUMMY_MEALS;
  List<Meal> favoriteMeals = [];
  List<String> prefsMealId = [];
  List<Category> availableCategory = [];

  void setFilters() async {
    availableMeals = DUMMY_MEALS.where((meal) {
      if (filters['gluten']! && !meal.isGlutenFree) {
        return false;
      }
      if (filters['lactose']! && !meal.isLactoseFree) {
        return false;
      }
      if (filters['vegan']! && !meal.isVegan) {
        return false;
      }
      if (filters['vegetarian']! && !meal.isVegetarian) {
        return false;
      }
      return true;
    }).toList();

    List<Category> ac = [];
    availableMeals.forEach((meal) {
      meal.categories.forEach((CatId) {
        DUMMY_CATEGORIES.forEach((cat) {
          if (cat.id == CatId) {
            if (!ac.any((cat) => cat.id == CatId)) ac.add(cat);
          }
        });
      });
    });
    availableCategory = ac;
    notifyListeners();
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.setBool('gluten', filters['gluten']!);
    _prefs.setBool('lactose', filters['lactose']!);
    _prefs.setBool('vegan', filters['vegan']!);
    _prefs.setBool('vegetarian', filters['vegetarian']!);
  }

  void getData() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    filters['gluten'] = _prefs.getBool('gluten') ?? false;
    filters['lactose'] = _prefs.getBool('lactose') ?? false;
    filters['vegan'] = _prefs.getBool('vegan') ?? false;
    filters['vegetarian'] = _prefs.getBool('vegetarian') ?? false;
    prefsMealId = _prefs.getStringList('prefsMealId') ?? [];
    for (var mealId in prefsMealId) {
      final existingIndex =
          favoriteMeals.indexWhere((meal) => meal.id == mealId);
      if (existingIndex < 0) {
        favoriteMeals.add(DUMMY_MEALS.firstWhere((meal) => meal.id == mealId));
      }
    }
    List<Meal> fm = [];
    favoriteMeals.forEach((favMeal) {
      availableMeals.forEach((avMeal) {
        if (favMeal.id == avMeal.id) fm.add(favMeal);
      });
    });
    favoriteMeals = fm;
    notifyListeners();
  }

  bool isMealFavorite = false;
  void toggleFavorite(String mealId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final existingIndex = favoriteMeals.indexWhere((meal) => meal.id == mealId);
    if (existingIndex >= 0) {
      favoriteMeals.removeAt(existingIndex);
      prefsMealId.remove(mealId);
    } else {
      favoriteMeals.add(
        DUMMY_MEALS.firstWhere((meal) => meal.id == mealId),
      );
      prefsMealId.add(mealId);
    }

    notifyListeners();
    prefs.setStringList('prefsMealId', prefsMealId);
  }

  bool isFavorite(String mealId) {
    return isMealFavorite = favoriteMeals.any((meal) => meal.id == mealId);
  }
}
