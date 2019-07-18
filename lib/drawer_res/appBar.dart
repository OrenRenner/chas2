import 'package:championat_asia_firstver/screens/searching.dart';
import 'package:drawerbehavior/drawerbehavior.dart';
import 'package:flutter/material.dart';

AppBarProps appBarView(BuildContext context, String language, String screenName){

  String screenName1 = "Home";
  var iconView = IconButton(
      icon: Icon(Icons.search),
      onPressed: () {
        Search.searchingTAG = "\"\"";
        Navigator.pushNamed(context, '/Search',);
      });
  if(screenName == 'home'){
    if (language.contains("ru")) screenName1 = "Главная";
    if (language.contains("uz")) screenName1 = "Асосий";
    if (language.contains("oz")) screenName1 = "Asosiy";
  } else if(screenName == 'match'){
    if (language.contains("ru")) screenName1 = "Матч-Центр(LIVE)";
    if (language.contains("uz")) screenName1 = "Матч-Центр(LIVE)";
    if (language.contains("oz")) screenName1 = "Match-Tsenter(LIVE)";
  } else if(screenName == 'tournirs'){
    if (language.contains("ru")) screenName1 = "Турниры";
    if (language.contains("uz")) screenName1 = "Турнирлар";
    if (language.contains("oz")) screenName1 = "Turnirlar";
  } else if(screenName == 'gallary'){
    if (language.contains("ru")) screenName1 = "Галерея";
    if (language.contains("uz")) screenName1 = "Галерея";
    if (language.contains("oz")) screenName1 = "Galereya";
  } else if(screenName == 'settings'){
    if (language.contains("ru")) screenName1 = "Настройки";
    if (language.contains("uz")) screenName1 = "Сузламалар";
    if (language.contains("oz")) screenName1 = "So'zlamalar";
  }
  return AppBarProps(
      title: Text(screenName1),
      actions: [iconView],
  );
}