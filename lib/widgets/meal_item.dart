import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/language_provider.dart';
import '../screens/meal_detail_screen.dart';
import '../models/meal.dart';

class MealItem extends StatelessWidget {
  final String id;

  final String imageUrl;
  final int duration;
  final Complexity complexity;
  final Affordability affordability;

  MealItem({
    required this.id,
    required this.imageUrl,
    required this.affordability,
    required this.complexity,
    required this.duration,
  });

  // String get complexityText {
  //   switch (complexity) {
  //     case Complexity.Simple:
  //       return 'Simple';
  //       break;
  //     case Complexity.Challenging:
  //       return 'Challenging';
  //       break;
  //     case Complexity.Hard:
  //       return 'Hard';
  //       break;
  //     default:
  //       return 'Unknown';
  //   }
  // }

  // String get affordabilityText {
  //   switch (affordability) {
  //     case Affordability.Affordable:
  //       return 'Affordable';
  //       break;
  //     case Affordability.Pricey:
  //       return 'Pricey';
  //       break;
  //     case Affordability.Luxurious:
  //       return 'Expensive';
  //       break;
  //     default:
  //       return 'Unknown';
  //   }
  // }

  void selectMeal(BuildContext context) {
    Navigator.of(context)
        .pushNamed(
      MealDetailScreen.routeName,
      arguments: id,
    )
        .then((result) {
      if (result != null) {
        // removeItem(result);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var lan = Provider.of<LanguageProvider>(context, listen: true);
    var dh = MediaQuery.of(context).size.height;
    return InkWell(
      onTap: () => selectMeal(context),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 4,
        margin: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  child: Hero(
                    tag: id,
                    child: InteractiveViewer(
                      child: FadeInImage(
                        placeholder: AssetImage('assets/images/a2.png'),
                        image: NetworkImage(
                          imageUrl,
                        ),
                        height: dh * 0.25,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  right: 10,
                  child: Container(
                    width: 300,
                    color: Colors.black54,
                    padding: EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 20,
                    ),
                    child: Text(
                      (lan.getTexts('meal-$id')).toString(),
                      style: TextStyle(
                        fontSize: 26,
                        color: Colors.white,
                      ),
                      softWrap: true,
                      overflow: TextOverflow.fade,
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.schedule,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      if (duration <= 10)
                        Text(
                          '$duration ' + lan.getTexts('min2').toString(),
                        ),
                      if (duration > 10)
                        Text(
                          '$duration ' + lan.getTexts('min').toString(),
                        ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.work,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      Text(
                        lan.getTexts('$complexity').toString(),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.attach_money,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      Text(lan.getTexts('$affordability').toString()),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
