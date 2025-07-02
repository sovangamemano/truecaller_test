package com.example.truecaller_test

import android.app.Service
import android.content.Intent
import android.os.Build
import android.util.Log
import com.google.firebase.messaging.FirebaseMessagingService
import com.google.firebase.messaging.RemoteMessage



class MyFirebaseMessagingService : FirebaseMessagingService() {

    override fun onMessageReceived(remoteMessage: RemoteMessage) {
        Log.d("FCM", "Message received: ${remoteMessage.data}")

        if (remoteMessage.data.isNotEmpty()) {
            val title = remoteMessage.data["title"] ?: "New Order"
            val orderId = remoteMessage.data["order_id"] ?: "0000"

            val overlayIntent = Intent(this, OverlayService::class.java)
                overlayIntent.putExtra("title", title)
                overlayIntent.putExtra("orderId", orderId)

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                this@MyFirebaseMessagingService.startForegroundService(overlayIntent)
            } else {
                this@MyFirebaseMessagingService.startService(overlayIntent)
            }
        }
    }

    override fun onNewToken(token: String) {
        super.onNewToken(token)
        Log.d("FCM", "New Token: $token")
        // You can send this token to your server
    }
}
