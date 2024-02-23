package com.example.integrations_flutter

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val channel = "channel/text"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, "channel/text").setMethodCallHandler { call, result ->
    if (call.method == "sendText") {
        val text = call.argument<String>("text")
        
        val processedText = "$text"
        result.success(processedText)
    } else {
        result.notImplemented()
    }
}

    }
}