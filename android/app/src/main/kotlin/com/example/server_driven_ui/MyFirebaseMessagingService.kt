package com.example.server_driven_ui

import android.app.*
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.PowerManager
import android.util.Log
import com.google.firebase.messaging.FirebaseMessagingService
import com.google.firebase.messaging.RemoteMessage
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.net.Uri
import android.provider.Settings
import androidx.core.app.NotificationCompat

class MyFirebaseMessagingService : FirebaseMessagingService() {
    override fun onMessageReceived(remoteMessage: RemoteMessage) {
    Log.d("FCM", "Message received")

    // Wake screen
    val powerManager = getSystemService(Context.POWER_SERVICE) as PowerManager
    val wakeLock = powerManager.newWakeLock(
        PowerManager.FULL_WAKE_LOCK or PowerManager.ACQUIRE_CAUSES_WAKEUP,
        "MyApp::WakeLock"
    )
    wakeLock.acquire(3000)

    // Notification data
    val orderId = remoteMessage.data["orderId"] ?: "0000"
    val title = remoteMessage.data["title"] ?: "New Order"
    val serviceIntent = Intent(this, OverlayService::class.java).apply {
        putExtra("title", title)
        putExtra("orderId", orderId)
    }

    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
        startForegroundService(serviceIntent)
    } else {
        startService(serviceIntent)
    }
    val fullScreenIntent = Intent(this, OrderAlertActivity::class.java).apply {
        flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
        putExtra("orderId", orderId)
        putExtra("title", title)
    }

    val fullScreenPendingIntent = PendingIntent.getActivity(
        this,
        0,
        fullScreenIntent,
        PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
    )

    val channelId = "order_channel"
    val notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
        val channel = NotificationChannel(
            channelId,
            "Order Notifications",
            NotificationManager.IMPORTANCE_HIGH
        ).apply {
            description = "Used for full-screen order alerts"
            lockscreenVisibility = NotificationCompat.VISIBILITY_PUBLIC
        }
        notificationManager.createNotificationChannel(channel)
    }

    val notification = NotificationCompat.Builder(this, channelId)
        .setSmallIcon(android.R.drawable.ic_dialog_info)
        .setContentTitle("Incoming Order")
        .setContentText("Order #$orderId: $title")
        .setPriority(NotificationCompat.PRIORITY_HIGH)
        .setCategory(NotificationCompat.CATEGORY_CALL)
        .setFullScreenIntent(fullScreenPendingIntent, true)
        .setAutoCancel(true)
        .build()

    Log.d("FCM", "Triggering full-screen notification")
    notificationManager.notify(101, notification)
}

}
