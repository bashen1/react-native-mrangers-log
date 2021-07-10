package com.reactnativerangersapplogreactnativeplugin

import android.util.Log
import com.bytedance.applog.AppLog
import com.bytedance.applog.ILogger
import com.bytedance.applog.InitConfig
import com.bytedance.applog.util.UriConstants
import com.facebook.react.bridge.*
import org.json.JSONException
import org.json.JSONObject
import java.util.*

class RangersApplogReactnativePluginModule(reactContext: ReactApplicationContext) : ReactContextBaseJavaModule(reactContext) {

    override fun getName(): String {
        return "RangersAppLogModule"
    }

    @ReactMethod
    fun init(params: ReadableMap, promise: Promise) {
        try {
            var appId = ""
            var channel = "Android"
            var abEnable = true
            var abEnableStr = "true"
            var showDebugLog = false
            var showDebugLogStr = "false"
            var logNeedEncrypt = true
            var logNeedEncryptStr = "true"

            if (params.getString("appId") != null) {
                appId = params.getString("appId")!!
            }

            if (params.getString("channel") != null) {
                channel = params.getString("channel")!!
            }

            if (params.getString("abEnable") != null) {
                abEnableStr = params.getString("abEnable")!!
                abEnable = abEnableStr == "true"
            }

            if (params.getString("showDebugLog") != null) {
                showDebugLogStr = params.getString("showDebugLog")!!
                showDebugLog = showDebugLogStr == "true"
            }

            if (params.getString("logNeedEncrypt") != null) {
                logNeedEncryptStr = params.getString("logNeedEncrypt")!!
                logNeedEncrypt = logNeedEncryptStr == "true"
            }

            if (appId != "") {
                val config = InitConfig(appId, channel) // appid和渠道，appid如不清楚请联系客户成功经理
                //上报域名只支持中国
                config.setUriConfig(UriConstants.DEFAULT)
                /// 是否在控制台输出日志，可用于观察用户行为日志上报情况
                if (showDebugLog) {
                    config.logger = ILogger { s, throwable -> Log.d("AppLog: ", "" + s) }
                }
                // 开启AB测试
                config.isAbEnable = abEnable;
                // 加密开关，SDK 5.5.1 及以上版本支持，false 为关闭加密，上线前建议设置为 true
                AppLog.setEncryptAndCompress(logNeedEncrypt)
                config.setAutoStart(true)
                AppLog.init(reactApplicationContext, config)
            }
        } catch (e: JSONException) {
            e.printStackTrace()
        }
    }

    @ReactMethod
    fun onEventV3(event: String, params: ReadableMap, promise: Promise) {
        try {
            val hashMap: HashMap<String, Any> = params.toHashMap()
            val jsonObject = JSONObject()
            for (key in hashMap.keys) {
                jsonObject.put(key, hashMap.get(key))
            }
            AppLog.onEventV3(event, jsonObject)
        } catch (e: JSONException) {
            e.printStackTrace()
        }
    }

    @ReactMethod
    fun setHeaderInfo(headerInfo: ReadableMap, promise: Promise) {
        AppLog.setHeaderInfo(headerInfo.toHashMap())
    }

    @ReactMethod
    fun setUserUniqueId(id: String, promise: Promise) {
        AppLog.setUserUniqueID(id)
    }

    @ReactMethod
    fun getAbSdkVersion(promise: Promise) {
        promise.resolve(AppLog.getAbSdkVersion())
    }

    @ReactMethod
    fun getABTestConfigValueForKey(key: String, defaultValue: String?, promise: Promise) {
        promise.resolve(AppLog.getAbConfig(key, defaultValue))
    }

    @ReactMethod
    fun getDeviceID(promise: Promise) {
        promise.resolve(AppLog.getDid())
    }
}