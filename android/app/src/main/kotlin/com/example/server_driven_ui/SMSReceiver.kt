package com.example.server_driven_ui

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.provider.Telephony
import android.util.Log
import android.widget.Toast


class SMSReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        if (Telephony.Sms.Intents.SMS_RECEIVED_ACTION == intent.action) {
            val bundle: Bundle? = intent.extras
            val msgs = Telephony.Sms.Intents.getMessagesFromIntent(intent)
            for (msg in msgs) {
                val sender = msg.displayOriginatingAddress
                val message = msg.displayMessageBody
                val time = msg.timestampMillis

                Log.d("SMS_SAVE", "Saving: $sender|||$message|||$time")

                // Save to SharedPreferences
                val sharedPref = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
                val existing = sharedPref.getString("flutter.sms_list", "") ?: ""
                val newEntry = "$sender|||$message|||$time\n"
                sharedPref.edit().putString("flutter.sms_list", existing + newEntry).apply()
                Toast.makeText(context, "SMS received from $sender", Toast.LENGTH_LONG).show()

            }
        }
    }
}
