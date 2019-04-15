package com.gmdigi.charon_app.quick_scan

import android.content.Intent
import android.content.Context;
import android.util.Log
import android.os.VibrationEffect;
import android.os.Vibrator;

import com.gmdigi.charon_app.quick_scan.Util.API
import com.gmdigi.charon_app.quick_scan.Util.MESSAGE_TYPE
import com.gmdigi.charon_app.quick_scan.Enity.MessageSet
import com.gmdigi.charon_app.quick_scan.Util.Config
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.common.PluginRegistry.Registrar
import com.google.gson.Gson
import io.flutter.plugin.common.EventChannel


class QuickScanPlugin : MethodCallHandler, PluginRegistry.NewIntentListener {
    private val TAG = this.javaClass.simpleName + " vic"
    private val gson = Gson()
    private var registrar: Registrar? = null
    private var new_intent = false

    companion object {
        val TAG = this.javaClass.simpleName + " vic"
        @JvmStatic
        fun registerWith(registrar: Registrar) {

            if (registrar.activity() == null) {
                return
            }

            val instance = QuickScanPlugin(registrar)
            val channel = MethodChannel(registrar.messenger(), "quick_scan")

            channel.setMethodCallHandler(instance)
            registrar.addNewIntentListener(instance)

            val eventchannel = EventChannel(registrar.messenger(), "charon_event_channel" )
            eventchannel.setStreamHandler(CommonStreamHandler())

            MethodChannel(registrar.messenger(), "charon_ready").setMethodCallHandler { call, result ->
                when{
                    call.method.equals("charon_ready_invoke") ->instance.invokeFunction(result)
                    call.method.equals("charon_vibrate") ->instance.vibrateFunction(result, registrar.context())
                    else -> result.notImplemented()
                }
            }
        }
    }

    fun invokeFunction(result: MethodChannel.Result) {
        Log.v(Companion.TAG, "ready")
        if (Config.notification_msg != null) {
            result.success(API.getmsg_call(Config.notification_msg!!))
        } else {
            result.notImplemented()
        }
    }

    fun vibrateFunction(result: MethodChannel.Result, context: Context){
        val vibrator: Vibrator = context.getSystemService(Context.VIBRATOR_SERVICE) as Vibrator
        if(vibrator.hasVibrator()){
            if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
                val vibrationEffect = VibrationEffect.createOneShot(300, VibrationEffect.DEFAULT_AMPLITUDE)
                vibrator.vibrate(vibrationEffect)
            } else {
                vibrator.vibrate(300)
            }
        }
        result.success("VibrationEffect!!");
    }


    private constructor(registrar: Registrar) {
        this.registrar = registrar
        var intent = registrar.activity().intent
        if(intent.data != null) {
            handle_intnet(intent)
        }
    }



    override fun onMethodCall(call: MethodCall, result: Result) {
        if (call.method == "getPlatformVersion") {
            result.success("Android ${android.os.Build.VERSION.RELEASE}")
        } else {
            result.notImplemented()
        }
    }

    override fun onNewIntent(intent: Intent): Boolean {
        new_intent = true
        if (intent.data != null) {
            //获取query中的数据
            handle_intnet(intent)
        }
        return false
    }

    fun handle_intnet(intent: Intent) {
        Log.v(TAG, "outside intent get")
        Config.notification_msg = gson.toJson(MessageSet(MESSAGE_TYPE.DEEP_LINK, intent.data!!.toString()))
        Log.v(TAG, Config.notification_msg)
        if(new_intent) {
            new_intent = false
            API.getmsg(gson.toJson(MessageSet(MESSAGE_TYPE.DEEP_LINK, intent.data!!.toString())))
        }
    }

    class CommonStreamHandler : EventChannel.StreamHandler {
        private var eventSink: EventChannel.EventSink? = null
        private val TAG = this.javaClass.simpleName + " vic"

        override fun onListen(argunents: Any?, sink: EventChannel.EventSink) {
            Log.v(TAG, "start listen")
            eventSink = sink

            API.setResultHandler(object : API.ResultHandler {
                override fun onReceive(msg: String) {
                    sendMSg(msg)
                }
            })
        }

        fun sendMSg(str: String) {
            Log.v(TAG, "send " + str)
            if (eventSink != null) {
                eventSink?.success(str)
                Config.notification_msg = null
            }
        }

        override fun onCancel(p0: Any?) {
            eventSink = null
        }
    }
}

