package com.reactnativerangersapplogreactnativeplugin

import android.app.Application
import android.net.Uri
import com.bytedance.applog.AppLog
import com.facebook.react.bridge.Promise
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod
import com.facebook.react.bridge.ReadableMap
import com.facebook.react.modules.core.DeviceEventManagerModule.RCTDeviceEventEmitter
import org.json.JSONObject

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
        AppLog.onEventV3(event, convertMapToJson(params))
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
    fun getDeviceIDSync(): String? {
        return AppLog.getDid()
    }

    @ReactMethod(isBlockingSynchronousMethod = true)
    fun getUserUniqueIDSync(): String? {
        return AppLog.getUserUniqueID()
    }

    @ReactMethod(isBlockingSynchronousMethod = true)
    fun getSsidSync(): String? {
        return AppLog.getSsid()
    }

    @ReactMethod
    fun getAttributionData(promise: Promise) {
        if (attributionData != null) {
            val params = convertJsonToMap(attributionData!!)
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
        var attributionData: JSONObject? = null
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
        fun onAttributionData(routingInfo: JSONObject?, exception: Exception?) {
            if (routingInfo !== null) {
                val params = convertJsonToMap(routingInfo)
                attributionData = routingInfo
                applicationContext?.getJSModule(RCTDeviceEventEmitter::class.java)?.emit("AttributionDataEvent", params)
            }
        }

        @JvmStatic
        fun onALinkData(routingInfo: JSONObject?, exception: Exception?) {
            if (routingInfo !== null) {
                val params = convertJsonToMap(routingInfo)
                applicationContext?.getJSModule(RCTDeviceEventEmitter::class.java)?.emit("ALinkDataEvent", params)
            }
        }
    }
}
