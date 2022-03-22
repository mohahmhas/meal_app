import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/language_provider.dart';
import 'package:flutter_complete_guide/providers/meal_provider.dart';
import 'package:provider/provider.dart';

import '../widgets/meal_item.dart';
import '../models/meal.dart';

class CategoryMealsScreen extends StatefulWidget {
  static const routeName = '/category-meals';

  @override
  _CategoryMealsScreenState createState() => _CategoryMealsScreenState();
}

class _CategoryMealsScreenState extends State<CategoryMealsScreen> {
  String categoryTitle = '';
  String categoryId = '';
  List<Meal> displayedMeals = <Meal>[];

  @override
  @override
  void didChangeDependencies() {
    final List<Meal> availableMeals =
        Provider.of<MealProvider>(context).availableMeals;

    final routeArgs =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;

    categoryId = routeArgs['id']!;
    displayedMeals = availableMeals.where((meal) {
      return meal.categories.contains(categoryId);
    }).toList();

    super.didChangeDependencies();
  }

  // void _removeMeal(String mealId) {
  //   setState(() {
  //     displayedMeals.removeWhere((meal) => meal.id == mealId);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    var dw = MediaQuery.of(context).size.width;
    var lan = Provider.of<LanguageProvider>(context, listen: true);
    return Directionality(
      textDirection: lan.isEn ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(lan.getTexts('cat-$categoryId').toString()),
        ),
        body: GridView.builder(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            childAspectRatio: isLandscape ? dw / (dw / 0.8) : dw / (dw * 0.75),
            maxCrossAxisExtent: dw <= 400 ? 400 : 500,
          ),
          itemBuilder: (ctx, index) {
            return MealItem(
              id: displayedMeals[index].id,
              imageUrl: displayedMeals[index].imageUrl,
              duration: displayedMeals[index].duration,
              affordability: displayedMeals[index].affordability,
              complexity: displayedMeals[index].complexity,
            );
          },
          itemCount: displayedMeals.length,
        ),
      ),
    );
  }
}
