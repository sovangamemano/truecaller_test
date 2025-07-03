package com.example.server_driven_ui

import android.content.Intent
import android.os.Build
import android.util.Log
import com.google.firebase.messaging.FirebaseMessagingService
import com.google.firebase.messaging.RemoteMessage

class MyFirebaseMessagingService : FirebaseMessagingService() {
    override fun onMessageReceived(remote: RemoteMessage) {
        remote.data.let {
            val intent = Intent(this, OverlayService::class.java)
                .putExtra("title", it["title"])
                .putExtra("orderId", it["order_id"])
                .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                Log.d("FCM", "Service started via FCM if")
                startForegroundService(intent)
            } else {
                Log.d("FCM", "Service started via FCM else")
                startService(intent)
            }
            Log.d("FCM", "Overlay triggered by FCM")
        }
    }
}
