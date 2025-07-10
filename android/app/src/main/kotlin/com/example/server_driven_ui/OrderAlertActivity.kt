package com.example.server_driven_ui

import android.app.KeyguardManager
import android.content.Context
import android.os.Bundle
import android.view.WindowManager
import android.widget.Button
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import android.os.PowerManager
import android.util.Log

class OrderAlertActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        Log.d("OrderAlert", "Activity Launched")

        // Turn screen on and dismiss keyguard
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O_MR1) {
            setShowWhenLocked(true)
            setTurnScreenOn(true)
        } else {
            window.addFlags(
                WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON or
                WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON or
                WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED
            )
        }

        // Dismiss keyguard (lock screen)
        val keyguardManager = getSystemService(Context.KEYGUARD_SERVICE) as KeyguardManager
        val keyguardLock = keyguardManager.newKeyguardLock("OrderAlert")
        keyguardLock.disableKeyguard()

        // Wake the screen
        val powerManager = getSystemService(Context.POWER_SERVICE) as PowerManager
        val wakeLock = powerManager.newWakeLock(
            PowerManager.FULL_WAKE_LOCK or
            PowerManager.ACQUIRE_CAUSES_WAKEUP or
            PowerManager.ON_AFTER_RELEASE,
            "OrderAlert::WakeLock"
        )
        wakeLock.acquire(3000)

        setContentView(R.layout.activity_order_alert)

        val orderId = intent.getStringExtra("orderId") ?: "0000"
        val title = intent.getStringExtra("title") ?: "New Order"

        findViewById<TextView>(R.id.orderTitle).text = "Order #$orderId: $title"

        findViewById<Button>(R.id.acceptButton).setOnClickListener {
            Log.d("OrderAlert", "Order Accepted")
            finish()
        }

        findViewById<Button>(R.id.rejectButton).setOnClickListener {
            Log.d("OrderAlert", "Order Rejected")
            finish()
        }
    }
}
