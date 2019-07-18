import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../drawer_scale_icon.dart';

_save(String chooseLang, BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  final key = 'my_lang_key';
  final value = chooseLang;
  prefs.setString(key, value);
  Navigator.of(context).pushReplacementNamed("/App");
}

Widget headerView(BuildContext context, String language, String username, bool isAuthorizated) {
  var firstContainer = GestureDetector();
  var secondContainer = GestureDetector();
  /*if(language.contains("ru")){
    firstContainer = GestureDetector(
        onTap:(){
          _save('uz', context);
        },
        child: Column(
          children: <Widget>[
            Container(
              width:30,
              height: 30,
              decoration: BoxDecoration(
                color: Colors.deepPurple,
                image: DecorationImage(
                    image:AssetImage("assets/uzbek.png"),
                    fit:BoxFit.cover
                ),
              ),
              //child: Center(child: Text("clickMe")),
            ),
            Center(child: Text("Узбек Тили", style: TextStyle(color: Colors.white, fontSize: 15, fontStyle: FontStyle.normal, fontWeight: FontWeight.bold),))
          ],
        )
    );
    secondContainer = GestureDetector(
        onTap:(){
          _save('oz', context);
        },
        child: Column(
          children: <Widget>[
            Container(
              width:30,
              height: 30,
              decoration: BoxDecoration(
                color: Colors.deepPurple,
                image: DecorationImage(
                    image:AssetImage("assets/uzbek.png"),
                    fit:BoxFit.cover
                ),
              ),
              //child: Center(child: Text("clickMe")),
            ),
            Center(child: Text("O'zbek Tili", style: TextStyle(color: Colors.white, fontSize: 15,  fontStyle: FontStyle.normal, fontWeight: FontWeight.bold),))
          ],
        )
    );
  } else if(language.contains("uz")){
    firstContainer = GestureDetector(
        onTap:(){
          _save('ru', context);
        },
        child: Column(
          children: <Widget>[
            Container(
              width:30,
              height: 30,
              decoration: BoxDecoration(
                color: Colors.deepPurple,
                image: DecorationImage(
                    image:AssetImage("assets/russian.png"),
                    fit:BoxFit.cover
                ),
              ),
              //child: Center(child: Text("clickMe")),
            ),
            Center(child: Text("Русский Язык", style: TextStyle(color: Colors.white, fontSize: 15,  fontStyle: FontStyle.normal, fontWeight: FontWeight.bold),))
          ],
        )
    );
    secondContainer = GestureDetector(
        onTap:(){
          _save('oz', context);
        },
        child: Column(
          children: <Widget>[
            Container(
              width:30,
              height: 30,
              decoration: BoxDecoration(
                color: Colors.deepPurple,
                image: DecorationImage(
                    image:AssetImage("assets/uzbek.png"),
                    fit:BoxFit.cover
                ),
              ),
              //child: Center(child: Text("clickMe")),
            ),
            Center(child: Text("O'zbek Tili", style: TextStyle(color: Colors.white, fontSize: 15,  fontStyle: FontStyle.normal, fontWeight: FontWeight.bold),))
          ],
        )
    );
  } else if(language.contains("oz")){
    firstContainer = GestureDetector(
        onTap:(){
          _save('ru', context);
        },
        child: Column(
          children: <Widget>[
            Container(
              width:30,
              height: 30,
              decoration: BoxDecoration(
                color: Colors.deepPurple,
                image: DecorationImage(
                    image:AssetImage("assets/russian.png"),
                    fit:BoxFit.cover
                ),
              ),
              //child: Center(child: Text("clickMe")),
            ),
            Center(child: Text("Русский Язык", style: TextStyle(color: Colors.white, fontSize: 15, fontStyle: FontStyle.normal, fontWeight: FontWeight.bold),))
          ],
        )
    );
    secondContainer = GestureDetector(
        onTap:(){
          _save('uz', context);
        },
        child: Column(
          children: <Widget>[
            Container(
              width:30,
              height: 30,
              decoration: BoxDecoration(
                color: Colors.deepPurple,
                image: DecorationImage(
                    image:AssetImage("assets/uzbek.png"),
                    fit:BoxFit.cover
                ),
              ),
              //child: Center(child: Text("clickMe")),
            ),
            Center(child: Text("Узбек Тили", style: TextStyle(color: Colors.white, fontSize: 15, fontStyle: FontStyle.normal),))
          ],
        )
    );
  }*/
  return Column(
    children: <Widget>[
      Container(
        padding: EdgeInsets.fromLTRB(16, 12, 16, 0),
        child: InkWell(
          child: Row(
            children: <Widget>[
              Container(
                  width: 48.0,
                  height: 48.0,
                  decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      image: new DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage("assets/chas.png")))),
              Container(
                  margin: EdgeInsets.only(left: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        username,
                        style: Theme.of(context)
                            .textTheme
                            .title
                            .copyWith(color: Colors.white),
                      )
                    ],
                  ))
            ],
          ),
          onTap: () {
            Navigator.pushNamed(
              context,
              '/Auth',
            );
          },
        )
      ),
      Divider(
        color: Colors.white.withAlpha(200),
        height: 16,
      ),
      Container(
        padding: EdgeInsets.fromLTRB(16, 12, 16, 0),
        /*child: Row(
          children: <Widget>[
            firstContainer,
            Container(width: 30,),
            secondContainer
          ],
        ),*/
      ),
      Container(height: 100,),
    ],
  );
}