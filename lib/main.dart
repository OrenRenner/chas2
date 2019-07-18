import 'package:championat_asia_firstver/Authorization.dart';
import 'package:championat_asia_firstver/screens/home_screen/CommentsScreen.dart';
import 'package:championat_asia_firstver/screens/match_screen/MatchDetails.dart';
import 'package:championat_asia_firstver/screens/searching.dart';
import 'package:championat_asia_firstver/screens/tournirs_screen/TournirsOverview.dart';
import 'package:flutter/material.dart';
import 'package:championat_asia_firstver/drawer_scale_icon.dart';
import 'package:championat_asia_firstver/splash_screen.dart';
import 'package:championat_asia_firstver/screens/home_screen/NewsScreen.dart';
import 'package:championat_asia_firstver/screens/home_screen/MatchScreen.dart';
import 'package:championat_asia_firstver/screens/home_screen/NewsDetails.dart';
import 'package:championat_asia_firstver/screens/gallary_screen/photo_screen/PhotoDetailsScreen.dart';

// Запуск приложения
void main() => runApp(MyApp());

// Основной виджет приложения
class MyApp extends StatelessWidget {

  // Формируем маршрутизацию приложения
  final routes = <String, WidgetBuilder>{
    // Путь, по которому создаётся Home Screen
    '/Home': (BuildContext context) => DrawerScaleIcon(),
    '/Splash': (BuildContext context) => SplashScreen(),
    '/App': (BuildContext context) => MyApp(),
    '/News': (BuildContext context) => NewsScreen(),
    '/Match': (BuildContext context) => MatchScreen(),
    '/NewsDetails' : (BuildContext context) => NewsDetailsScreen(),
    '/PhotoDetails': (BuildContext context) => PhotoDetailsScreen(),
    '/Auth': (BuildContext context) => Authorization(),
    '/Search': (BuildContext context) => Search(),
    '/Comments': (BuildContext context) => CommentsScreen(),
    '/MatchDetails': (BuildContext context) => MatchDetails(),
    '/TournirsOverview': (BuildContext context) => TournirsOverview(),
  };

  // Необходимо переопределить метод строительства инстанса виджета
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          accentColor: Colors.amberAccent,
          /*appBarTheme: AppBarTheme(
           elevation: 0, // This removes the shadow from all App Bars.
          ),*/
      ),
      title: 'Championat Asia',
      // в котором будет Splash Screen с указанием следующего маршрута
      home: SplashScreen(nextRoute: '/Home'),
      // передаём маршруты в приложение
      routes: routes,
    );
  }
}

