package com.example.truecaller_test

import android.content.ComponentName
import android.content.Context
import android.content.pm.PackageManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val channel = "app.icon.switcher"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            channel
        ).setMethodCallHandler { call, result ->
            if (call.method == "changeIcon") {
                val alias = call.argument<String>("alias")
                changeIcon(alias ?: "DefaultAlias")
                result.success(null)
            }
        }
    }

    private fun changeIcon(targetAlias: String) {
        val aliases = listOf("DefaultAlias", "KrishnaAlias", "JungleAlias")
        val pm = applicationContext.packageManager

        for (alias in aliases) {
            val state = if (alias == targetAlias)
                PackageManager.COMPONENT_ENABLED_STATE_ENABLED
            else
                PackageManager.COMPONENT_ENABLED_STATE_DISABLED

            pm.setComponentEnabledSetting(
                ComponentName(this, "$packageName.$alias"),
                state,
                PackageManager.DONT_KILL_APP
            )
        }
    }

    // Now restart or exit app to avoid crash
    Handler(Looper.getMainLooper()).postDelayed({
        val intent = pm.getLaunchIntentForPackage(packageName)
        intent?.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP or Intent.FLAG_ACTIVITY_NEW_TASK)
        startActivity(intent)
        Runtime.getRuntime().exit(0)
    }, 300)
}
