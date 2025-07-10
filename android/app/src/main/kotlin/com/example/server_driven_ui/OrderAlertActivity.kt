package com.example.server_driven_ui

import android.os.Bundle
import android.view.WindowManager
import android.widget.Button
import android.widget.TextView
import android.util.Log
import androidx.appcompat.app.AppCompatActivity
import io.flutter.plugin.common.MethodChannel
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.embedding.engine.dart.DartExecutor

class OrderAlertActivity : AppCompatActivity() {

    private lateinit var channel: MethodChannel
    private val CHANNEL = "overlay_action"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        window.addFlags(WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED)
        window.addFlags(WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON)

        setContentView(R.layout.activity_order_alert)

        val orderId = intent.getStringExtra("orderId") ?: "0000"
        val title = intent.getStringExtra("title") ?: "New Order"

        findViewById<TextView>(R.id.orderTitle).text = "Order #$orderId: $title"

        // Setup FlutterEngine if not already
        var engine = FlutterEngineCache.getInstance().get("main_engine")
        if (engine == null) {
            engine = FlutterEngine(this)
            engine.dartExecutor.executeDartEntrypoint(
                DartExecutor.DartEntrypoint.createDefault()
            )
            FlutterEngineCache.getInstance().put("main_engine", engine)
        }

        channel = MethodChannel(engine.dartExecutor.binaryMessenger, CHANNEL)

        findViewById<Button>(R.id.acceptButton).setOnClickListener {
            Log.d("OrderAlert", "Order Accepted")
            channel.invokeMethod("handleAction", mapOf("action" to "accept", "orderId" to orderId))
            finish()
        }

        findViewById<Button>(R.id.rejectButton).setOnClickListener {
            Log.d("OrderAlert", "Order Rejected")
            channel.invokeMethod("handleAction", mapOf("action" to "reject", "orderId" to orderId))
            finish()
        }
    }
}
