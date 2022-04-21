# react-native-mrangers-log

[![npm version](https://badge.fury.io/js/react-native-mrangers-log.svg)](https://badge.fury.io/js/react-native-mrangers-log)

此仓库基于rangers_applog_reactnative_plugin

`3.0.0 版本支持ALink，并且调整集成与初始化方式。最后一个老版本为2.2.1`

Android SDK Version: 6.9.6

iOS SDK Version: 6.9.0.1-bugfix

## 开始

`$ npm install react-native-mrangers-log -E`

>在使用 RangersAppLog SDK 前，你需要先[注册DataRangers账号](https://datarangers.com.cn/help/doc?lid=1867&did=40001)并且创建一个应用。

## 插件安装与初始化

### iOS

1. 打开`ios/Podfile`文件，添加以下

```pod
require_relative '../node_modules/@react-native-community/cli-platform-ios/native_modules'
·······
source 'https://github.com/CocoaPods/Specs.git'
source 'https://github.com/volcengine/volcengine-specs.git'
source 'https://github.com/bytedance/cocoapods_sdk_source_repo.git'


·······
target
```

2. 添加 rangersapplog.XXXXXXX 的UrlScheme，`注意替换XXXXXXX为自己的`
3. 添加Universal Link，注意替换xxx为自己的

```xml
<string>applinks:xxx.volctracer.com</string>
```

4. 打开ios/XXX/`AppDelegate.h`，添加`BDAutoTrackAlinkRouting`（ALink所需）

```c++
...
#import <RangersAppLog/RangersAppLog.h>
  
@interface AppDelegate : UIResponder <UIApplicationDelegate, BDAutoTrackAlinkRouting>

@property (nonatomic, strong) UIWindow *window;

@end
```

5. 打开ios/XXX/`AppDelegate.m`，添加（ALink所需）

```c++
...
#import "RangersAppLogModule.h"
  
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  ...
  // 如果需要测试alink的延迟深度链接，需要改渠道或者版本号
  [RangersAppLogModule initializeSDK:self launchOptions:launchOptions appId:@"appId" appName:@"appName" channel:@"channel"];
  ...
}

...
// 末尾添加
//************************************************头条ALink监听回调************************************************
#pragma mark --BDAutoTrackAlinkRouting--
- (void)onAttributionData:(nullable NSDictionary *)routingInfo error:(nullable NSError *)error {
  [RangersAppLogModule onAttributionData:routingInfo error:error];
}

- (void)onALinkData:(nullable NSDictionary *)routingInfo error:(nullable NSError *)error {
  [RangersAppLogModule onALinkData:routingInfo error:error];
}

/// 开启剪切板读取，裂变所需
- (bool)shouldALinkSDKAccessPasteBoard {
    return true;
}
//************************************************头条ALink监听回调************************************************

@end
```

### Android

1. 在 android 根目录 的 build.gradle 中添加:

```javascript
buildscript {
  repositories {
    ...
    maven {
      url 'https://artifact.bytedance.com/repository/Volcengine/'
    }
  }
  dependencies {
    ...
    // 头条火山
    classpath 'com.bytedance.applog:RangersAppLog-All-plugin:6.9.6'
  }
}

allprojects {
  repositories {
    ...
    maven {
      url 'https://artifact.bytedance.com/repository/Volcengine/'
    }
  }
}

```

2. 在 app module 的 build.gradle 并在 defaultConfig 中添加:

```javascript
defaultConfig {
  ...
  manifestPlaceholders.put("APPLOG_SCHEME", "rangersapplog.XXXXXXXXX".toLowerCase())
}

```

3. 打开`android/app/src/main/AndroidManifest.xml`配置AppLinks（ALink所需）

```xml
@@ -1,101 +1,112 @@
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools"
    package="com.XXXX">

    ...
    <application>
        <activity
            android:name=".MainActivity"
            android:configChanges="screenLayout|smallestScreenSize|keyboard|keyboardHidden|orientation|screenSize|uiMode"
            android:label="@string/app_name"
            android:launchMode="singleTask"
            android:screenOrientation="portrait"
            android:windowSoftInputMode="adjustResize">
            .......
            <!--添加下面-->
            <intent-filter>
                <action android:name="android.intent.action.VIEW" />

                <category android:name="android.intent.category.DEFAULT" />
                <category android:name="android.intent.category.BROWSABLE" />
              
                <!-- XXXXX.volctracer.com 此处的网址为ALink后台的链接-->
                <data
                    android:scheme="https"
                    android:host="XXXXX.volctracer.com"
                    android:pathPrefix="/a" />
            </intent-filter>
            <!--添加上面-->
        </activity>
        .......
    </application>

</manifest>

```

4. 打开android/app/src/main/java/com/XXXX/`MainApplication.java`，添加初始化代码

```java
...
import com.reactnativerangersapplogreactnativeplugin.RangersApplogReactnativePluginModule;
...

public class MainApplication extends MultiDexApplication implements ReactApplication {
 ...
   @Override
   public void onCreate() {
    // 如果需要测试alink的延迟深度链接，需要改渠道或者版本号，120为重试的次数，500ms一次，火山默认为10，隐私合规需要注意下方的Bool值
    RangersApplogReactnativePluginModule.initializeSDK(this, "appId", "channel", 120, true, true, true, false);
   }
 ...
}
```

## 插件接口文档

### 基础接口

| 接口名                     | 功能                              | 参数                                                        | 支持平台     |
|----------------------------|-----------------------------------|-------------------------------------------------------------|--------------|
| init | 初始化 | 参数：字典，不可空，参考index.js | iOS，Android |
| onEvent                  | 生成自定义埋点                    | 参数1：string，非空。事件名。 参数2：字典，可空。事件参数。 | iOS, Android |
| start                  | init 之后需要调用start，为了隐私合规                    | 无 | iOS, Android |
| flush                  | 主动触发上报。SDK有频率限制，每10s最多可以触发一次                    | 无 | iOS, Android |

### 用户属性

| 接口名                     | 功能                              | 参数                                                        | 支持平台     |
|----------------------------|-----------------------------------|-------------------------------------------------------------|--------------|
| profileSet              | 设置用户属性，存在则覆盖，不存在则创建 | 参数：字典，不可空。                       | iOS, Android |
| profileSetOnce           | 设置用户属性，存在则不设置，不存在则创建，适合首次相关的用户属性，比如首次访问时间等     | 参数：字典，不可空。                      | iOS, Android |
| profileIncrement              | 设置数值类型的属性，可进行累加 | 参数：字典，不可空。                       | iOS, Android |
| profileAppend           | 向用户的某个 List 类型的属性添加属性，比如爱好  | 参数：字典，不可空。                     | iOS, Android |
| profileUnset           | 删除用户的属性  | 参数：字符串，不可空                      | iOS, Android |

### 事件公共属性

| 接口名                     | 功能                              | 参数                                                        | 支持平台     |
|----------------------------|-----------------------------------|-------------------------------------------------------------|--------------|
| setHeaderInfo              | 自定义header信息 设置用户公共属性 | 参数1：字典，可空。自定义header信息。                       | iOS, Android |
| removeHeaderInfo           | 移除自定义事件公共属性  | 参数：字符串，不可空                      | iOS, Android |

### A/B测试

| 接口名                     | 功能                              | 参数                                                        | 支持平台     |
|----------------------------|-----------------------------------|-------------------------------------------------------------|--------------|
| getAbSdkVersion            | 获取全部客户端和服务端已曝光参数  | 参数：无 返回：str                                          | iOS, Android          |
| getABTestConfigValueForKey | 【异步】获取AB测试的配置，若不存在返回nil | 参数1: str, ABTest配置的key 返回：str或nil                  | iOS, Android          |
| getABTestConfigValueForKeySync | 【同步】获取AB测试的配置，若不存在返回nil | 参数1: str, ABTest配置的key 返回：str或nil | iOS, Android |
| getAllAbTestConfigs | 获取ABTest相关配置，此接口不会触发曝光，可以随意读取。如果正常为了做实验，请勿使用此接口，请使用getABTestConfigValueForKey、getABTestConfigValueForKeySync接口 | 参数: 无返回：object | iOS, Android |

### 用户信息

| 接口名            | 功能             | 参数                                | 支持平台     |
| ----------------- | ---------------- | ----------------------------------- | ------------ |
| setUserUniqueId   | 设置用户UUID     | 参数1：string，可空。user_unique_id | iOS, Android |
| getUserUniqueID   | 获取绑定后的UUID | 参数：无 返回：str、null、undefined | iOS, Android |
| clearUserUniqueId | 清除UUID         | 参数：无 返回：无                   | iOS, Android |

### 设备信息

| 接口名                     | 功能                              | 参数                                                        | 支持平台     |
|----------------------------|-----------------------------------|-------------------------------------------------------------|--------------|
| getDeviceID                | 获取did                   | 参数：无 返回：str。                                        | iOS, Android          |
| getSsid | 获取ssid | 参数：无 返回：str、null、undefined | iOS, Android |

### ALink

| 接口名                     | 功能                                                         | 参数                                     | 支持平台     |
| -------------------------- | ------------------------------------------------------------ | ---------------------------------------- | ------------ |
| getAttributionData         | 获取延迟深度链接的归因数据                                   | 参数：无 返回：object、null、undefined。 | iOS, Android |
| addALinkDataListener       | 添加深度链接唤醒监听，需要配合RN的Link与模块的initALinkUrl   | 参数：function(ret){}                    | iOS, Android |
| addAttributionDataListener | 添加首次启动归因监听                                         | 参数：function(ret){}                    | iOS, Android |
| initALinkUrl               | 深度链接，此方法符合条件会触发addALinkDataListener，需配合RN的Link | 参数：字符串                             | iOS, Android |

ALink接口的调用顺序为先添加监听，再调用模块的start方法

## License

MIT
