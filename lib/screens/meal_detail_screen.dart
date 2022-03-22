import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../providers/meal_provider.dart';
import '../dummy_data.dart';

class MealDetailScreen extends StatelessWidget {
  static const routeName = '/meal-detail';

  Widget buildSectionTitle(BuildContext context, String text) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleLarge,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget buildContainer(Widget child, BuildContext context) {
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    var dw = MediaQuery.of(context).size.width;
    var dh = MediaQuery.of(context).size.height;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.all(15),
      padding: EdgeInsets.all(10),
      height: isLandscape ? dh * 0.5 : dh * 0.25,
      width: isLandscape ? (dw * 0.5 - 30) : dw,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    var lan = Provider.of<LanguageProvider>(context, listen: true);

    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    final mealId = ModalRoute.of(context)!.settings.arguments as String;
    final selectedMeal = DUMMY_MEALS.firstWhere((meal) => meal.id == mealId);
    var accentColor = Theme.of(context).colorScheme.secondary;
    List<String> stepsLi = lan.getTexts('steps-$mealId') as List<String>;
    var liSteps = ListView.builder(
      padding: EdgeInsets.all(0),
      itemBuilder: (ctx, index) => Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              child: Text('# ${(index + 1)}'),
            ),
            title: Text(
              stepsLi[index],
              style: TextStyle(color: Colors.black),
            ),
          ),
          Divider()
        ],
      ),
      itemCount: stepsLi.length,
    );
    List<String> liIngredientli =
        lan.getTexts('ingredients-$mealId') as List<String>;
    var liIngradients = ListView.builder(
      padding: EdgeInsets.all(0),
      itemBuilder: (ctx, index) => Card(
        color: accentColor,
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 5,
            horizontal: 10,
          ),
          child: Text(
            liIngredientli[index],
            style: TextStyle(
                // color: useWhiteForeground(accentColor)
                //     ? Colors.white
                //     : Colors.black
                ),
          ),
        ),
      ),
      itemCount: liIngredientli.length,
    );
    return Directionality(
      textDirection: lan.isEn ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 300,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(lan.getTexts('meal-$mealId').toString()),
                background: Hero(
                  tag: mealId,
                  child: InteractiveViewer(
                    child: FadeInImage(
                      placeholder: AssetImage('assets/images/a2.png'),
                      image: NetworkImage(
                        selectedMeal.imageUrl,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            SliverList(
                delegate: SliverChildListDelegate([
              if (isLandscape)
                Row(
                  children: [
                    Column(
                      children: [
                        buildSectionTitle(
                            context, lan.getTexts('Ingredients').toString()),
                        buildContainer(liIngradients, context),
                      ],
                    ),
                    Column(
                      children: [
                        buildSectionTitle(
                            context, lan.getTexts('Steps').toString()),
                        buildContainer(liSteps, context),
                      ],
                    )
                  ],
                ),
              if (!isLandscape)
                buildSectionTitle(
                    context, lan.getTexts('Ingredients').toString()),
              if (!isLandscape) buildContainer(liIngradients, context),
              if (!isLandscape)
                buildSectionTitle(context, lan.getTexts('Steps').toString()),
              if (!isLandscape) buildContainer(liSteps, context),
            ]))
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Provider.of<MealProvider>(context, listen: true).isFavorite(mealId)
                ? Icons.star
                : Icons.star_border,
          ),
          onPressed: () => Provider.of<MealProvider>(context, listen: false)
              .toggleFavorite(mealId),
        ),
      ),
    );
  }

  useWhiteForeground(Color backgroundColor, {double bias = 0.0}) {}
}
