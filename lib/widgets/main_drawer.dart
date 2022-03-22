import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/language_provider.dart';
import '../screens/filters_screen.dart';
import '../screens/theme_screen.dart';

class MainDrawer extends StatelessWidget {
  Widget buildListTile(
      String title, IconData icon, Function() tapHandler, BuildContext ctx) {
    return ListTile(
      leading: Icon(
        icon,
        size: 26,
        color: Theme.of(ctx).splashColor,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: Theme.of(ctx).textTheme.bodyText1!.color,
          fontFamily: 'RobotoCondensed',
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: tapHandler,
    );
  }

  @override
  Widget build(BuildContext context) {
    var lan = Provider.of<LanguageProvider>(context, listen: true);
    return Directionality(
      textDirection: lan.isEn ? TextDirection.ltr : TextDirection.rtl,
      child: Drawer(
        elevation: 0,
        child: Column(
          children: <Widget>[
            Container(
              height: 120,
              width: double.infinity,
              padding: EdgeInsets.all(20),
              alignment:
                  lan.isEn ? Alignment.bottomLeft : Alignment.bottomRight,
              color: Theme.of(context).colorScheme.secondary,
              child: Text(
                (lan.getTexts('drawer_name')).toString(),
                style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 30,
                    color: Theme.of(context).colorScheme.primary),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            buildListTile(
                (lan.getTexts("drawer_item1")).toString(), Icons.restaurant,
                () {
              Navigator.of(context).pushReplacementNamed('/');
            }, context),
            buildListTile(
                (lan.getTexts("drawer_item2")).toString(), Icons.settings, () {
              Navigator.of(context)
                  .pushReplacementNamed(FiltersScreen.routeName);
            }, context),
            buildListTile(
                (lan.getTexts("drawer_item3")).toString(), Icons.color_lens,
                () {
              Navigator.of(context).pushReplacementNamed(ThemesScreen.routname);
            }, context),
            Divider(
              height: 10,
              color: Colors.black45,
            ),
            Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(top: 20, right: 22),
              child: Text(
                (lan.getTexts("drawer_switch_title")).toString(),
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20, left: 20, bottom: 20),
              child: Row(
                children: [
                  Text(
                    (lan.getTexts('drawer_switch_item1')).toString(),
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  Switch(
                      value:
                          Provider.of<LanguageProvider>(context, listen: true)
                              .isEn,
                      onChanged: (newValue) {
                        Provider.of<LanguageProvider>(context, listen: false)
                            .changeLan(newValue);
                        Navigator.of(context).pop();
                      }
                      // inactiveTrackColor: Provider.of<ThemeProvider>(context,listen: true).tm,
                      ),
                  Text(
                    (lan.getTexts('drawer_switch_item2')).toString(),
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ],
              ),
            ),
            Divider(
              height: 10,
              color: Colors.black45,
            ),
          ],
        ),
      ),
    );
  }
}
