package com.example.server_driven_ui

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
        overlayView = LayoutInflater.from(this).inflate(R.layout.overlay_layout, null)
        val params = WindowManager.LayoutParams(
            WindowManager.LayoutParams.MATCH_PARENT,
            WindowManager.LayoutParams.WRAP_CONTENT,
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O)
                WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
            else
                WindowManager.LayoutParams.TYPE_PHONE,
            WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE or
            WindowManager.LayoutParams.FLAG_LAYOUT_IN_SCREEN or
            WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS,
            PixelFormat.TRANSLUCENT
        )
        params.gravity = Gravity.TOP
        windowManager = getSystemService(WINDOW_SERVICE) as WindowManager
        windowManager.addView(overlayView, params)
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
            val launchIntent = packageManager.getLaunchIntentForPackage(packageName)
            if (launchIntent != null) {
                Log.d("OverlayService", "Accept clicked for Order #$orderId")
                launchIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP)
                launchIntent.putExtra("action", "accept")
                launchIntent.putExtra("orderId", orderId)
                startActivity(launchIntent)
            }
            stopSelf()
        }

        rejectBtn.setOnClickListener {
            val launchIntent = packageManager.getLaunchIntentForPackage(packageName)
            if (launchIntent != null) {
                Log.d("OverlayService", "Reject clicked for Order #$orderId")
                launchIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP)
                launchIntent.putExtra("action", "reject")
                launchIntent.putExtra("orderId", orderId)
                startActivity(launchIntent)
            }
            stopSelf()
        }

        return START_NOT_STICKY
    }


    private fun getNotification(): Notification {
        val channelId = "overlay_channel"
        val nm = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val chan = NotificationChannel(channelId, "Overlay", NotificationManager.IMPORTANCE_LOW)
            nm.createNotificationChannel(chan)
        }
        return NotificationCompat.Builder(this, channelId)
            .setContentTitle("Incoming Order").setContentText("Tap to respond")
            .setSmallIcon(android.R.drawable.ic_dialog_info).setOngoing(true).build()
    }

    override fun onDestroy() { if (::windowManager.isInitialized) windowManager.removeView(overlayView) }
    override fun onBind(intent: Intent?): IBinder? = null
}
