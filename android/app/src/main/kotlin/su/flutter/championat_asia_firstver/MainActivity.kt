package su.flutter.championat_asia_firstver

import android.os.Bundle
//import android.flutter.plugins.share.SharePlugin

import io.flutter.app.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity() {
  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    //SharePlugin.register(this)
    GeneratedPluginRegistrant.registerWith(this)
  }
}
