import 'package:drawerbehavior/drawerbehavior.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:championat_asia_firstver/drawer_res/heaserView.dart';
import 'package:championat_asia_firstver/drawer_res/appBar.dart';
import 'package:championat_asia_firstver/drawer_res/menuView.dart';
import 'package:championat_asia_firstver/screens/home_screen/HomeScreen.dart';
import 'package:championat_asia_firstver/screens/match_screen/MatchScreen.dart';
import 'package:championat_asia_firstver/screens/gallary_screen/GallaryScreen.dart';
import 'package:championat_asia_firstver/screens/tournirs_screen/TournirsScreen.dart';
import 'package:championat_asia_firstver/screens/settings.dart';

class DrawerScaleIcon extends StatefulWidget {

  // ignore: non_constant_identifier_names
  static bool is_authorizated;
  static String username;
  //const DrawerScaleIcon({Key key, @required this.language}): super(key: key);
  @override
  _DrawerScaleIconState createState() => _DrawerScaleIconState();
}

class _DrawerScaleIconState extends State<DrawerScaleIcon> {
  String language;
  bool is_authorizated = DrawerScaleIcon.is_authorizated;
  String username = DrawerScaleIcon.username;
  var selectedMenuItemId;
  Widget _widget;

  /*
  _save(String chooseLang, BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'my_lang_key';
    final value = chooseLang;
    prefs.setString(key, value);
    Navigator.of(context).pushReplacementNamed("/App");
  }*/

  _read() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = 'my_lang_key';
      setState(() {
        language = prefs.getString(key) ?? 'en';
        _widget = HomeScreen();
        selectedMenuItemId = 'home';
      });
    } catch(e){
      print(e);
    }
  }


  @override
  // ignore: must_call_super
  void initState() {
    _read();
  }

  @override
  Widget build(BuildContext context) {
    print("User is authorizated is " + is_authorizated.toString());
    return this.language != null ? DrawerScaffold(
        percentage: 1,
        appBar: appBarView(context, this.language, selectedMenuItemId),
        menuView: MenuView(
          headerView: headerView(context, this.language, this.username, is_authorizated),
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.only(left: 40.0, top: 15.0, bottom: 17.0, ),
          menu: menuView(context, language),
          animation: true,
          color: Theme.of(context).primaryColor,
          selectedItemId: selectedMenuItemId,
          onMenuItemSelected: (String itemId) {
            selectedMenuItemId = itemId;
            if (itemId == 'home') {
              setState(() => _widget = HomeScreen());
            } else if(itemId == 'match'){
              setState(() => _widget = MatchScreen());
            } else if(itemId == 'gallary'){
              setState(() => _widget = GallaryScreen());
            } else if(itemId == 'tournirs'){
              setState(() => _widget = TournirsScreen());
            } else if(itemId == 'settings'){
              setState(() => _widget = Settings());
            }
          },
        ),
        contentView: Screen(
          contentBuilder: (context) => LayoutBuilder(
                builder: (context, constraint) => GestureDetector(
                      child: Container(
                        color: Colors.red,
                        width: constraint.maxWidth,
                        height: constraint.maxHeight,
                        child: Container(color: Colors.white, child: _widget),
                      ),
                    ),
              ),
          color: Colors.red,
        )
    ) : Center(child: CircularProgressIndicator());
  }
}
