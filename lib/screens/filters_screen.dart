import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/language_provider.dart';
import 'package:flutter_complete_guide/providers/theme_provider.dart';

import '../widgets/main_drawer.dart';
import 'package:provider/provider.dart';
import '../providers/meal_provider.dart';

class FiltersScreen extends StatelessWidget {
  static const routeName = '/filters';
  final bool fromOnBoarding;
  FiltersScreen({this.fromOnBoarding = false});

  Widget buildSwitchListTile(
    String title,
    String description,
    bool currentValue,
    Function(bool) updateValue,
    BuildContext ctx,
  ) {
    return SwitchListTile(
      title: Text(title),
      value: currentValue,
      subtitle: Text(
        description,
      ),
      inactiveTrackColor:
          Provider.of<ThemeProvider>(ctx, listen: true).tm == ThemeMode.light
              ? null
              : Colors.black,
      onChanged: updateValue,
    );
  }

  @override
  Widget build(BuildContext context) {
    var lan = Provider.of<LanguageProvider>(context, listen: true);
    final Map<String, bool> currentFilters =
        Provider.of<MealProvider>(context, listen: true).filters;
    return Directionality(
      textDirection: lan.isEn ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
        drawer: MainDrawer(),
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: false,
              title: fromOnBoarding
                  ? null
                  : Text(
                      lan.getTexts('filters_appBar_title').toString(),
                    ),
              backgroundColor: fromOnBoarding
                  ? Theme.of(context).canvasColor
                  : Theme.of(context).primaryColor,
              elevation: fromOnBoarding ? 0 : 5,
            ),
            SliverList(
                delegate: SliverChildListDelegate([
              Container(
                padding: EdgeInsets.all(20),
                child: Text(
                  lan.getTexts('filters_screen_title').toString(),
                  style: Theme.of(context).textTheme.headline6,
                  textAlign: TextAlign.center,
                ),
              ),
              buildSwitchListTile(
                  lan.getTexts('Gluten-free').toString(),
                  lan.getTexts('Gluten-free-sub').toString(),
                  currentFilters['gluten']!, (newValue) {
                currentFilters['gluten'] = newValue;

                Provider.of<MealProvider>(context, listen: false).setFilters();
              }, context),
              buildSwitchListTile(
                  lan.getTexts('Lactose-free').toString(),
                  lan.getTexts('Lactose-free_sub').toString(),
                  currentFilters['lactose']!, (newValue) {
                currentFilters['lactose'] = newValue;
                Provider.of<MealProvider>(context, listen: false).setFilters();
              }, context),
              buildSwitchListTile(
                  lan.getTexts('Vegetarian').toString(),
                  lan.getTexts('Vegetarian-sub').toString(),
                  currentFilters['vegetarian']!, (newValue) {
                currentFilters['vegetarian'] = newValue;
                Provider.of<MealProvider>(context, listen: false).setFilters();
              }, context),
              buildSwitchListTile(
                  lan.getTexts('Vegan').toString(),
                  lan.getTexts('Vegan-sub').toString(),
                  currentFilters['vegan']!, (newValue) {
                currentFilters['vegan'] = newValue;

                Provider.of<MealProvider>(context, listen: false).setFilters();
              }, context),
              SizedBox(
                height: fromOnBoarding ? 80 : 0,
              )
            ]))
          ],
        ),
      ),
    );
  }
}
