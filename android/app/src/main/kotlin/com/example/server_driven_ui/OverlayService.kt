package com.example.server_driven_ui

import android.app.*
import android.content.Context
import android.content.Intent
import android.graphics.PixelFormat
import android.os.*
import android.util.Log
import android.view.*
import android.widget.Button
import android.widget.TextView
import androidx.core.app.NotificationCompat

class OverlayService : Service() {

    private lateinit var windowManager: WindowManager
    private lateinit var overlayView: View
    private var wakeLock: PowerManager.WakeLock? = null

    override fun onCreate() {
        super.onCreate()

        // Inflate the overlay layout
        overlayView = LayoutInflater.from(this).inflate(R.layout.overlay_layout, null)

        val params = WindowManager.LayoutParams(
            WindowManager.LayoutParams.MATCH_PARENT,
            WindowManager.LayoutParams.WRAP_CONTENT,
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O)
                WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
            else
                WindowManager.LayoutParams.TYPE_PHONE,
            WindowManager.LayoutParams.FLAG_LAYOUT_IN_SCREEN or
                    WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL or
                    WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED or
                    WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON or
                    WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON or
                    WindowManager.LayoutParams.FLAG_DISMISS_KEYGUARD,
            PixelFormat.TRANSLUCENT
        )
        params.gravity = Gravity.TOP

        // Add the overlay view
        windowManager = getSystemService(WINDOW_SERVICE) as WindowManager
        windowManager.addView(overlayView, params)

        // Acquire WakeLock to wake the screen
        val powerManager = getSystemService(Context.POWER_SERVICE) as PowerManager
        wakeLock = powerManager.newWakeLock(
            PowerManager.FULL_WAKE_LOCK or PowerManager.ACQUIRE_CAUSES_WAKEUP,
            "OverlayService::WakeLock"
        )
        wakeLock?.acquire(5000) // 5 seconds to ensure screen wakes up

        // Start foreground to keep service alive
        startForeground(101, getNotification())
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        Log.d("OverlayService", "Service started via FCM")

        val orderId = intent?.getStringExtra("orderId") ?: "0000"
        val title = intent?.getStringExtra("title") ?: "New Order"

        overlayView.findViewById<TextView>(R.id.orderTitle).text = "Order #$orderId: $title"

        val acceptBtn = overlayView.findViewById<Button>(R.id.acceptButton)
        val rejectBtn = overlayView.findViewById<Button>(R.id.rejectButton)

        acceptBtn.setOnClickListener {
            Log.d("OverlayService", "Accept clicked for Order #$orderId")
            launchMainAppWithAction("accept", orderId)
            stopSelf()
        }

        rejectBtn.setOnClickListener {
            Log.d("OverlayService", "Reject clicked for Order #$orderId")
            launchMainAppWithAction("reject", orderId)
            stopSelf()
        }

        return START_NOT_STICKY
    }

    private fun launchMainAppWithAction(action: String, orderId: String) {
        val launchIntent = packageManager.getLaunchIntentForPackage(packageName)
        if (launchIntent != null) {
            launchIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP)
            launchIntent.putExtra("action", action)
            launchIntent.putExtra("orderId", orderId)
            startActivity(launchIntent)
        }
    }

    private fun getNotification(): Notification {
        val channelId = "overlay_channel"
        val nm = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val chan = NotificationChannel(
                channelId, "Overlay Channel", NotificationManager.IMPORTANCE_LOW
            )
            nm.createNotificationChannel(chan)
        }
        return NotificationCompat.Builder(this, channelId)
            .setContentTitle("Incoming Order")
            .setContentText("Waiting for response...")
            .setSmallIcon(android.R.drawable.ic_dialog_info)
            .setOngoing(true)
            .build()
    }

    override fun onDestroy() {
        super.onDestroy()
        if (::windowManager.isInitialized) {
            windowManager.removeView(overlayView)
        }
        wakeLock?.release()
    }

    override fun onBind(intent: Intent?): IBinder? = null
}
