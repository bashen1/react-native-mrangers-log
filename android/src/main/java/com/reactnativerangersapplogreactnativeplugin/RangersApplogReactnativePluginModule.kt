package com.reactnativerangersapplogreactnativeplugin

import android.util.Log
import com.bytedance.applog.AppLog
import com.bytedance.applog.IDataObserver
import com.bytedance.applog.ILogger
import com.bytedance.applog.InitConfig
import com.bytedance.applog.util.UriConstants
import com.facebook.react.bridge.*
import org.json.JSONException
import org.json.JSONObject
import java.util.*

class RangersApplogReactnativePluginModule(reactContext: ReactApplicationContext) : ReactContextBaseJavaModule(reactContext) {

    private var allAbJSON: JSONObject? = null

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
                AppLog.addDataObserver(object : IDataObserver {
                    override fun onIdLoaded(s: String, s1: String, s2: String) {}
                    override fun onRemoteIdGet(b: Boolean, s: String, s1: String, s2: String, s3: String, s4: String, s5: String) {}
                    override fun onRemoteConfigGet(b: Boolean, jsonObject: JSONObject) {}
                    override fun onRemoteAbConfigGet(b: Boolean, jsonObject: JSONObject) {
                        allAbJSON = jsonObject
                    }

                    override fun onAbVidsChange(s: String, s1: String) {}
                })
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
    fun removeHeaderInfo(customKey: String, promise: Promise) {
        AppLog.removeHeaderInfo(customKey);
    }

    @ReactMethod
    fun profileSet(params: ReadableMap, promise: Promise) {
        AppLog.profileSet(convertMapToJson(params))
    }

    @ReactMethod
    fun profileSetOnce(params: ReadableMap, promise: Promise) {
        AppLog.profileSetOnce(convertMapToJson(params))
    }

    @ReactMethod
    fun profileIncrement(params: ReadableMap, promise: Promise) {
        AppLog.profileIncrement(convertMapToJson(params))
    }

    @ReactMethod
    fun profileAppend(params: ReadableMap, promise: Promise) {
        AppLog.profileAppend(convertMapToJson(params))
    }

    @ReactMethod
    fun profileUnset(customKey: String, promise: Promise) {
        AppLog.profileUnset(customKey)
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
    fun getAllAbSdkVersion(promise: Promise) {
        promise.resolve(allAbJSON.toString())
    }

    @ReactMethod
    fun getABTestConfigValueForKey(key: String, defaultValue: String?, promise: Promise) {
        promise.resolve(AppLog.getAbConfig(key, defaultValue))
    }

    @ReactMethod(isBlockingSynchronousMethod = true)
    fun getABTestConfigValueForKeySync(key: String, defaultValue: String?): String? {
        return AppLog.getAbConfig(key, defaultValue)
    }

    @ReactMethod
    fun getDeviceID(promise: Promise) {
        promise.resolve(AppLog.getDid())
    }

    @ReactMethod
    fun getUserUniqueID(promise: Promise) {
        promise.resolve(AppLog.getUserUniqueID())
    }

    @ReactMethod
    fun getSsid(promise: Promise) {
        promise.resolve(AppLog.getSsid())
    }
}
