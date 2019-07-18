import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget { // ignore: must_be_immutable
  @override
  State<StatefulWidget> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  String language;

  _read() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = 'my_lang_key';
      setState(() {
        language = prefs.getString(key) ?? '';
      });
    } catch(e){
      print(e);
    }
  }

  _save(String chooseLang, BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'my_lang_key';
    final value = chooseLang;
    prefs.setString(key, value);
    Navigator.of(context).pushReplacementNamed("/App");
  }

  @override
  void initState() {
    super.initState();
    _read();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 20.0),
              child: Center(child: Text("Choose Your Language:", style: TextStyle(color: Colors.black87, fontSize: 20),)),
            ),
            Container(height: 30,),
            GestureDetector(
                child: Container(
                  width:120,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    image: DecorationImage(
                        image:AssetImage("assets/russian.png"),
                        fit:BoxFit.cover
                    ),
                  ),
                  //child: Center(child: Text("clickMe")),
                ),
                onTap:(){
                  _save('ru', context);
                }
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 10.0),
              child: Center(child: Text("Русский Язык", style: TextStyle(color: Colors.black87, fontSize: 20),)),
            ),
            Container(height: 30,),
            GestureDetector(
                child: Container(
                  width:120,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    image: DecorationImage(
                        image:AssetImage("assets/uzbek.png"),
                        fit:BoxFit.cover
                    ),
                  ),
                  //child: Center(child: Text("clickMe")),
                ),
                onTap:(){
                  _save('uz', context);
                }
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 10.0),
              child: Center(child: Text("Узбек Тили", style: TextStyle(color: Colors.black87, fontSize: 20),)),
            ),
            Container(height: 30,),
            GestureDetector(
                child: Container(
                  width:120,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    image: DecorationImage(
                        image:AssetImage("assets/uzbek.png"),
                        fit:BoxFit.cover
                    ),
                  ),
                  //child: Center(child: Text("clickMe")),
                ),
                onTap:(){
                  _save('oz', context);
                }
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 10.0),
              child: Center(child: Text("O'zbek Tili", style: TextStyle(color: Colors.black87, fontSize: 20),)),
            ),
          ],
        ),
    );
  }
}

