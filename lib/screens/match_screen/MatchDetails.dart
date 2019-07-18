import 'package:championat_asia_firstver/screens/match_screen/EventView.dart';
import 'package:championat_asia_firstver/screens/match_screen/LineupView.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class MatchDetails extends StatefulWidget {
  static String logoName;
  static String type;
  static String id;

  @override
  State<StatefulWidget> createState() {
    return _MatchDetailsState();
  }
}

class _MatchDetailsState extends State<MatchDetails>{

  final String logoName = MatchDetails.logoName;
  String language;

  String events = "Events";
  String composition = "Compositions";
  String chat = "Chat";

  _read() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = 'my_lang_key';
      setState(() {
        language = prefs.getString(key) ?? 'en';
        if(language.contains("ru")){
          events = "События";
          composition = "Составы";
          chat = "Чат";
        } else if(language.contains("uz")){
          events = "Вокеялар";
          composition = "Таркиби";
          chat = "Чат";
        } else if(language.contains("oz")){
          events = "Voqealar";
          composition = "Tarkibi";
          chat = "Chat";
        }
      });
    } catch(e){
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _read();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(logoName),
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.event), text: events,),
              Tab(icon: Icon(Icons.people), text: composition,),
              Tab(icon: Icon(Icons.chat), text: chat,),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            EventView(),
            LineupView(),
            Center(child: Icon(Icons.add),),
          ],
        ),
      ),
    );
  }
}
