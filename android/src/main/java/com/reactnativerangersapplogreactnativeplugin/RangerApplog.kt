package com.reactnativerangersapplogreactnativeplugin

import android.app.Application
import android.util.Log
import com.bytedance.applog.AppLog
import com.bytedance.applog.ILogger
import com.bytedance.applog.InitConfig
import com.bytedance.applog.alink.IALinkListener
import com.bytedance.applog.util.UriConstants

object RangerApplog {
    fun initializeRangerApplog(application: Application?, appId: String?, channel: String?, deferDeepLinkRetryCount: Int) {
        val config = InitConfig(appId!!, channel!!) // appid和渠道，appid如不清楚请联系客户成功经理，注意第二个参数 channel 不能为空
        config.setUriConfig(UriConstants.DEFAULT) //上报地址，只支持中国
        config.isAbEnable = true // 开启 AB 测试

        // 是否在控制台输出日志，可用于观察用户行为日志上报情况，上线之前可去掉
//        config.isLogEnable = true;
//        config.logger = ILogger { s, _ -> Log.d("AppLog------->: ", "" + s) }

        AppLog.setEncryptAndCompress(true) // 加密开关，SDK 5.5.1 及以上版本支持，false 为关闭加密，上线前建议设置为 true
        config.setAutoStart(false) //初始化后立即上报【隐私合规】
        config.enableDeferredALink() //开启延迟深度链接
        config.isMacEnable = false //是否要获取Mac地址【隐私合规】
        config.deferDeepLinkRetryCount = deferDeepLinkRetryCount //延迟深度链接的超时重试次数，默认10次，重试间隔500ms
        AppLog.setClipboardEnabled(true) // 用于广告监测中的裂变
        AppLog.init(application!!, config) //初始化

        //ALink监听回调
        AppLog.setALinkListener(object : IALinkListener {
            override fun onALinkData(routingInfo: Map<String, String?>?, exception: Exception?) {
                RangersApplogReactnativePluginModule.onALinkData(routingInfo, exception)
            }

            override fun onAttributionData(routingInfo: Map<String, String?>?, exception: Exception?) {
                RangersApplogReactnativePluginModule.onAttributionData(routingInfo, exception)
            }
        })
        // AppLog.start() //开启上报【隐私合规】,需要调用模块的start的方法
    }
}