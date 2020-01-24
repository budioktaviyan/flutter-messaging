package id.flutter.messaging

import com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin

object CustomPluginRegistrant {

  fun registerWith(registry: PluginRegistry) {
    if (isRegisterWith(registry)) return
    FirebaseMessagingPlugin.registerWith(registry.registrarFor(FirebaseMessagingPlugin::class.java.canonicalName))
    FlutterLocalNotificationsPlugin.registerWith(registry.registrarFor(FlutterLocalNotificationsPlugin::class.java.canonicalName))
  }

  private fun isRegisterWith(registry: PluginRegistry): Boolean {
    val key = registry::class.java.canonicalName
    if (registry.hasPlugin(key)) return true
    registry.registrarFor(key)
    return false
  }
}