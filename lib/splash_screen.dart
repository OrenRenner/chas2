import 'dart:convert';
import 'dart:core';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:championat_asia_firstver/drawer_scale_icon.dart';

// Наследуемся от виджета с состоянием,
// то есть виджет для изменения состояния которого не требуется пересоздавать его инстанс
class SplashScreen extends StatefulWidget {
  // переменная для хранения маршрута
  final String nextRoute;

  // конструктор, тело конструктора перенесено в область аргументов,
  // то есть сразу аргументы передаются в тело коструктора и устанавливаются внутренним переменным
  // Dart позволяет такое
  SplashScreen({this.nextRoute});


  // все подобные виджеты должны создавать своё состояние,
  // нужно переопределять данный метод
  @override
  State<StatefulWidget> createState() => _SplashScreenState();
}

// Создаём состояние виджета
class _SplashScreenState extends State<SplashScreen> {

  String url = 'https://championat.asia/api/home';
  int data = 0;
  String language = '';
  bool is_authorizated = false; // ignore: non_constant_identifier_names
  String token;
  String username;

  // Инициализация состояния
  @override
  void initState() {
    super.initState();
    _read();
    makeRequest();
    _testToken();
  }


  _testToken() async{
    try {
      final prefs1 = await SharedPreferences.getInstance();
      final key = 'token';
      setState(() {
        token = prefs1.getString(key) ?? '';
      });
    } catch(e){
      print(e);
    }

    try{
      var extractdata = json.decode(token);
      String test_token = "https://championat.asia/api/user/token";
      var response1 = await http
          .post(Uri.encodeFull(test_token),
          headers: {
            "Accept": "application/json",
            "Authorization": extractdata["data"]["token_type"].toString() + " " + extractdata["data"]["access_token"].toString()
          });
      extractdata = json.decode(response1.body);
      if(response1.statusCode == 200 && extractdata["data"]["valid"]){
        setState(() {
          is_authorizated = true;
          username = extractdata["data"]["name"].toString();
        });
      } else {
        setState(() {
          is_authorizated = false;
          username = "Championat Asia";
        });
      }
    }catch(e){
      setState(() {
        is_authorizated = false;
        username = "Championat Asia";
      });
    }
  }

  // ignore: missing_return
  Future<String> makeRequest() async {
    try {
      var response = await http
          .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
      setState(() {
        if (response.statusCode == 200 && response != null) {
          setState(() {
            data = 1;
          });
        } else {
          setState(() {
            data = -1;
          });
        }
      });
    } catch(e){
      setState(() {
        data = -1;
      });
    }
  }

  _read() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = 'my_lang_key';
      setState(() {
        language = prefs.getString(key) ?? '';
        print(language);
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
    DrawerScaleIcon.username = username;
    DrawerScaleIcon.is_authorizated = is_authorizated;
    Navigator.of(context).pushReplacementNamed(widget.nextRoute);
  }

  // Формирование виджета
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    width = width / 2;
    if(data == 1){
      if(language.contains('ru') || language.contains('uz') || language.contains('oz')) {
        Timer(
            Duration(seconds: 4),
            // Для этого используется статический метод навигатора
            // Это очень похоже на передачу лямбда функции в качестве аргумента std::function в C++
            () {
              DrawerScaleIcon.username = username;
              DrawerScaleIcon.is_authorizated = is_authorizated;
              Navigator.of(context).pushReplacementNamed(widget.nextRoute);
            }
        );
        return Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset('assets/chas.png', width: width, height: width,),
                /*JumpingDotsProgressIndicator(
                  numberOfDots: 5,
                  fontSize: 30.0,
                ),*/
                CircularProgressIndicator(),
              ],
            ),
          ),
        );
      } else {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Center(child: Text("Choose Your Language:", style: TextStyle(color: Colors.black87, fontSize: 20),)),
                ),
                Container(height: 30,),
                GestureDetector(
                  child: Container(
                      width: 120,
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
                  child: Center(child: Text("O'zbek Tili", style: TextStyle(color: Colors.black87, fontSize: 20),)),
                ),
              ],
            ),
          ),
        );
      }
    } else if(data != 1 && data != 0){
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset('assets/chas.png', width: width, height: width,),
              Text("Check Your Internet Connection"),
            ],
          ),
        ),
      );
    } else if(data == 0){
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset('assets/chas.png', width: width, height: width,)
            ],
          ),
        ),
      );
    } else return null;
  }

}