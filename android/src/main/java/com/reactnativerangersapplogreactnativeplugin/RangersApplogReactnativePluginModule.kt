package com.reactnativerangersapplogreactnativeplugin

import android.app.Application
import android.net.Uri
import androidx.annotation.Nullable
import com.bytedance.applog.AppLog
import com.facebook.react.bridge.*
import com.facebook.react.modules.core.DeviceEventManagerModule.RCTDeviceEventEmitter
import org.json.JSONException
import org.json.JSONObject
import java.util.*

class RangersApplogReactnativePluginModule(reactContext: ReactApplicationContext) : ReactContextBaseJavaModule(reactContext) {

    override fun getName(): String {
        return "RangersAppLogModule"
    }

    @ReactMethod
    fun init(params: ReadableMap, promise: Promise) {
        var appId = ""
        if (params.hasKey("appId")) {
            appId = params.getString("appId")!!
        }
        applicationContext = reactApplicationContext
    }

    @ReactMethod
    fun start(promise: Promise) {
        AppLog.start()
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
    fun flush(promise: Promise) {
        AppLog.flush()
    }

    @ReactMethod
    fun setHeaderInfo(headerInfo: ReadableMap, promise: Promise) {
        AppLog.setHeaderInfo(headerInfo.toHashMap())
    }

    @ReactMethod
    fun removeHeaderInfo(customKey: String, promise: Promise) {
        AppLog.removeHeaderInfo(customKey)
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
    fun clearUserUniqueId() {
        AppLog.setUserUniqueID(null)
    }

    @ReactMethod
    fun getAbSdkVersion(promise: Promise) {
        promise.resolve(AppLog.getAbSdkVersion())
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
    fun getAllAbTestConfigs(promise: Promise) {
        promise.resolve(AppLog.getAllAbTestConfigs().toString())
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

    @ReactMethod(isBlockingSynchronousMethod = true)
    fun getDeviceIDSync():String? {
        return AppLog.getDid()
    }

    @ReactMethod(isBlockingSynchronousMethod = true)
    fun getUserUniqueIDSync():String? {
        return AppLog.getUserUniqueID()
    }

    @ReactMethod(isBlockingSynchronousMethod = true)
    fun getSsidSync():String? {
        return AppLog.getSsid()
    }

    @ReactMethod
    fun getAttributionData(promise: Promise) {
        if (attributionData != null) {
            val params = Arguments.createMap()
            for ((key, value) in attributionData!!) {
                params.putString(key, value)
            }
            promise.resolve(params)
        } else {
            promise.resolve(null)
        }
    }

    @ReactMethod
    fun initALinkUrl(url: String) {
        var appLinkData = Uri.parse(url)
        if (url == "") {
            appLinkData = null
        }
        AppLog.activateALink(appLinkData)
    }

    companion object {
        var attributionData: Map<String, String?>? = null
        var applicationContext: ReactApplicationContext? = null

        @JvmStatic
        fun initializeSDK(
                application: Application,
                appId: String,
                channel: String,
                isMacEnable: Boolean,
                isAndroidIdEnabled: Boolean,
                isOaidEnabled: Boolean,
                isLogEnable: Boolean
        ) {
            RangerApplog.initializeRangerApplog(
                    application,
                    appId,
                    channel,
                    isMacEnable,
                    isAndroidIdEnabled,
                    isOaidEnabled,
                    isLogEnable
            )
        }

        @JvmStatic
        fun onAttributionData(@Nullable routingInfo: Map<String, String?>?, @Nullable exception: Exception?) {
            if (routingInfo !== null) {
                val params = Arguments.createMap()
                for ((key, value) in routingInfo) {
                    params.putString(key, value)
                }
                attributionData = routingInfo
                applicationContext?.getJSModule(RCTDeviceEventEmitter::class.java)?.emit("AttributionDataEvent", params)
            }
        }

        @JvmStatic
        fun onALinkData(@Nullable routingInfo: Map<String, String?>?, @Nullable exception: Exception?) {
            if (routingInfo !== null) {
                val params = Arguments.createMap()
                for ((key, value) in routingInfo) {
                    params.putString(key, value)
                }

                applicationContext?.getJSModule(RCTDeviceEventEmitter::class.java)?.emit("ALinkDataEvent", params)
            }
        }
    }
}
