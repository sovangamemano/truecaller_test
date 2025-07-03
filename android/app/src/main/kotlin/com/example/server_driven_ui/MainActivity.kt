package com.example.server_driven_ui

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.Bundle
import android.provider.Settings
import android.net.Uri
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel


class MainActivity : FlutterActivity() {

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "overlay_channel")
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "showOverlay" -> {
                        if (!Settings.canDrawOverlays(this)) {
                            val intent = Intent(Settings.ACTION_MANAGE_OVERLAY_PERMISSION)
                            intent.data = Uri.parse("package:$packageName")
                            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                            startActivity(intent)
                            result.success("permission_required")
                        } else {
                            val orderId = call.argument<String>("orderId") ?: "0000"
                            val title = call.argument<String>("title") ?: "New Order"
                            val intent = Intent(this, OverlayService::class.java).apply {
                                putExtra("orderId", orderId)
                                putExtra("title", title)
                            }
                            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                                startForegroundService(intent)
                            } else {
                                startService(intent)
                            }
                            result.success("started")
                        }
                    }
                    else -> result.notImplemented()
                }
            }
    }

    // These must be outside configureFlutterEngine

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        handleOverlayAction(intent)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        handleOverlayAction(intent)
    }

    private fun handleOverlayAction(intent: Intent?) {
        val action = intent?.getStringExtra("action")
        val orderId = intent?.getStringExtra("orderId")
        if (action != null && orderId != null) {
            MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, "overlay_action")
                .invokeMethod("handleAction", mapOf("action" to action, "orderId" to orderId))
        }
    }
}


// {
//   "to": "<DEVICE_TOKEN>",
//   "data": {
//     "title": "Zomato Order",
//     "order_id": "8976"
//   }
// }
