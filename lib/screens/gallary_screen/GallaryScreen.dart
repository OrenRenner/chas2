import 'package:flutter/material.dart';
import 'package:championat_asia_firstver/screens/gallary_screen/photo_screen/PhotoScreen.dart';
import 'package:championat_asia_firstver/screens/gallary_screen/video_screen/VideoScreen.dart';


class GallaryScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GallaryScreenState();
}

class _GallaryScreenState extends State<GallaryScreen>{

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.photo), text: "Photos",),
                Tab(icon: Icon(Icons.videocam), text: "Videos",),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              PhotoScreen(),
              VideoScreen(),
            ],
          ),
        ),
      );
  }
}