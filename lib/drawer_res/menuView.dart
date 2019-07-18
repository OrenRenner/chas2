import 'package:drawerbehavior/drawerbehavior.dart';
import 'package:flutter/material.dart';

Menu menuView(BuildContext context, String language){
  String homeName;
  String matchName;
  String tournirsName;
  String gallaryName;
  String settingsName;

  if (language.contains("ru")) {
    homeName = 'Главная'; matchName = 'Матч-Центр(LIVE)'; tournirsName = 'Турниры'; gallaryName = 'Галерея'; settingsName = 'Сменить язык';
  }
  if (language.contains("uz")) {
    homeName = 'Асосий'; matchName = 'Матч-Центр(LIVE)'; tournirsName = 'Турнирлар'; gallaryName = 'Галерея'; settingsName = 'Тилни узгартириш';
  }
  if (language.contains("oz")) {
    homeName = 'Asosiy'; matchName = 'Match-Tsentr(LIVE)'; tournirsName = 'Turnirlar'; gallaryName = 'Galareya'; settingsName = 'Tilni o`zgartirish';
  }

  return new Menu(
    items: [
      new MenuItem(
        id: 'home',
        title: homeName,
        icon: Icons.apps,
      ),
      new MenuItem(
        id: 'match',
        title: matchName,
        icon: Icons.calendar_today,
      ),
      new MenuItem(
        id: 'tournirs',
        title: tournirsName,
        icon: Icons.language,
      ),
      new MenuItem(
        id: 'gallary',
        title: gallaryName,
        icon: Icons.photo,
      ),
      new MenuItem(
        id: 'settings',
        title: settingsName,
        icon: Icons.settings,
      ),
    ],
  );
}