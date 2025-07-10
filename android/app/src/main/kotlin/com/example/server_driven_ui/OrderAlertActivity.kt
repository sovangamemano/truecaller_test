package com.example.server_driven_ui

import android.app.KeyguardManager
import android.content.Context
import android.os.Build
import android.os.Bundle
import android.view.WindowManager
import android.widget.Button
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import android.util.Log
import android.content.Intent
import android.net.Uri
import android.os.PowerManager
import android.provider.Settings

class OrderAlertActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Unlock screen if locked
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O_MR1) {
            setShowWhenLocked(true)
            setTurnScreenOn(true)
            val km = getSystemService(Context.KEYGUARD_SERVICE) as KeyguardManager
            km.requestDismissKeyguard(this, null)
        } else {
            window.addFlags(
                WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED or
                WindowManager.LayoutParams.FLAG_DISMISS_KEYGUARD or
                WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON or
                WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON
            )
        }

        setContentView(R.layout.activity_order_alert)

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            val intent = Intent()
            val packageName = packageName
            val pm = getSystemService(Context.POWER_SERVICE) as PowerManager
            if (!pm.isIgnoringBatteryOptimizations(packageName)) {
                intent.action = android.provider.Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS
                intent.data = android.net.Uri.parse("package:$packageName")
                startActivity(intent)
            }
        }


        val orderId = intent.getStringExtra("orderId") ?: "0000"
        val title = intent.getStringExtra("title") ?: "New Order"

        findViewById<TextView>(R.id.orderTitle).text = "Order #$orderId: $title"

        findViewById<Button>(R.id.acceptButton).setOnClickListener {
            Log.d("OrderAlert", "Accepted")
            // TODO: Send result to Flutter via broadcast or intent
            finish()
        }

        findViewById<Button>(R.id.rejectButton).setOnClickListener {
            Log.d("OrderAlert", "Rejected")
            // TODO: Send result to Flutter via broadcast or intent
            finish()
        }
    }
}
