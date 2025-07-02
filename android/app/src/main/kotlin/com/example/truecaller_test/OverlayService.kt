package com.example.truecaller_test

import android.app.*
import android.content.Context
import android.content.Intent
import android.graphics.PixelFormat
import android.os.Build
import android.os.IBinder
import android.util.Log
import android.view.*
import android.widget.Button
import android.widget.TextView
import androidx.core.app.NotificationCompat

class OverlayService : Service() {

    private lateinit var windowManager: WindowManager
    private lateinit var overlayView: View

    override fun onCreate() {
        super.onCreate()

        // Inflate the overlay layout
        val inflater = getSystemService(LAYOUT_INFLATER_SERVICE) as LayoutInflater
        overlayView = inflater.inflate(R.layout.overlay_layout, null)

        // Read order details from intent
        val orderId = /*intent?.getStringExtra("orderId") ?:*/ "0000"
        val title = /*intent?.getStringExtra("title") ?:*/ "New Order"

        // Set up layout params for overlay
        val params = WindowManager.LayoutParams(
            WindowManager.LayoutParams.MATCH_PARENT,
            WindowManager.LayoutParams.WRAP_CONTENT,
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O)
                WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
            else
                WindowManager.LayoutParams.TYPE_PHONE,
            WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE or
                    WindowManager.LayoutParams.FLAG_LAYOUT_IN_SCREEN,
            PixelFormat.TRANSLUCENT
        )
        params.gravity = Gravity.TOP

        // Add the overlay to screen
        windowManager = getSystemService(WINDOW_SERVICE) as WindowManager
        windowManager.addView(overlayView, params)

        // Set text dynamically
        overlayView.findViewById<TextView>(R.id.orderTitle).text =
            "Order #$orderId: $title"

        // Accept Button: Launch app with intent
        overlayView.findViewById<Button>(R.id.acceptButton).setOnClickListener {
            Log.d("OverlayService", "Accept clicked for Order #$orderId")
            val launchIntent = Intent(this, MainActivity::class.java).apply {
                flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
                putExtra("action", "accept")
                putExtra("orderId", orderId)
            }
            startActivity(launchIntent)
            stopSelf()
        }

        // Reject Button: Just close
        overlayView.findViewById<Button>(R.id.rejectButton).setOnClickListener {
            Log.d("OverlayService", "Reject clicked for Order #$orderId")
            val launchIntent = Intent(this, MainActivity::class.java).apply {
                flags = Intent.FLAG_ACTIVITY_NEW_TASK
                putExtra("action", "reject")
                putExtra("orderId", orderId)
            }
            startActivity(launchIntent)
            stopSelf()
        }

        // Start foreground notification to keep service alive
        showForegroundNotification()
    }

    private fun showForegroundNotification() {
        val channelId = "overlay_channel"
        val notificationManager =
            getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                channelId,
                "Overlay Notification Channel",
                NotificationManager.IMPORTANCE_LOW
            )
            notificationManager.createNotificationChannel(channel)
        }

        val notification = NotificationCompat.Builder(this, channelId)
            .setContentTitle("Processing order...")
            .setSmallIcon(android.R.drawable.ic_dialog_info)
            .setOngoing(true)
            .build()

        startForeground(101, notification)
    }

    override fun onDestroy() {
        super.onDestroy()
        if (::windowManager.isInitialized && ::overlayView.isInitialized) {
            windowManager.removeView(overlayView)
        }
    }

    override fun onBind(intent: Intent?): IBinder? = null
}
