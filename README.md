# react-native-mrangers-log

[![npm version](https://badge.fury.io/js/react-native-mrangers-log.svg)](https://badge.fury.io/js/react-native-mrangers-log)

此仓库基于rangers_applog_reactnative_plugin

Android SDK Version: 6.5.0

iOS SDK Version: 6.4.0

## 开始

`$ npm install react-native-mrangers-log -E`

>在使用 RangersAppLog SDK 前，你需要先[注册DataRangers账号](https://datarangers.com.cn/help/doc?lid=1867&did=40001)并且创建一个应用。


## 插件安装与初始化

### iOS

1. 打开`ios/Podfile`文件，添加以下
```
require_relative '../node_modules/@react-native-community/cli-platform-ios/native_modules'
·······
source 'https://github.com/CocoaPods/Specs.git'
source 'https://github.com/volcengine/volcengine-specs.git'
source 'https://github.com/bytedance/cocoapods_sdk_source_repo.git'


·······
target
```

2. 添加 rangersapplog.XXXXXXX 的UrlScheme，注意替换

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


## 插件接口文档

### 基础接口

| 接口名                     | 功能                              | 参数                                                        | 支持平台     |
|----------------------------|-----------------------------------|-------------------------------------------------------------|--------------|
| init | 初始化 | 参数：字典，不可空，参考index.js | iOS，Android |
| onEventV3                  | 生成自定义埋点                    | 参数1：string，非空。事件名。 参数2：字典，可空。事件参数。 | iOS, Android |

### 用户属性

| 接口名                     | 功能                              | 参数                                                        | 支持平台     |
|----------------------------|-----------------------------------|-------------------------------------------------------------|--------------|
| profileSet              | 设置用户属性，存在则覆盖，不存在则创建 | 参数：字典，不可空。                       | iOS, Android |
| profileSetOnce           | 设置用户属性，存在则不设置，不存在则创建，适合首次相关的用户属性，比如首次访问时间等			  | 参数：字典，不可空。                      | iOS, Android |
| profileIncrement              | 设置数值类型的属性，可进行累加 | 参数：字典，不可空。                       | iOS, Android |
| profileAppend           | 向用户的某个 List 类型的属性添加属性，比如爱好			  | 参数：字典，不可空。                     | iOS, Android |
| profileUnset           | 删除用户的属性			  | 参数：字符串，不可空                      | iOS, Android |


### 事件公共属性

| 接口名                     | 功能                              | 参数                                                        | 支持平台     |
|----------------------------|-----------------------------------|-------------------------------------------------------------|--------------|
| setHeaderInfo              | 自定义header信息 设置用户公共属性 | 参数1：字典，可空。自定义header信息。                       | iOS, Android |
| removeHeaderInfo           | 移除自定义事件公共属性			  | 参数：字符串，不可空                      | iOS, Android |

### A/B测试

| 接口名                     | 功能                              | 参数                                                        | 支持平台     |
|----------------------------|-----------------------------------|-------------------------------------------------------------|--------------|
| getAbSdkVersion            | 获取全部客户端和服务端已曝光参数  | 参数：无 返回：str                                          | iOS, Android          |
| getABTestConfigValueForKey | 【异步】获取AB测试的配置，若不存在返回nil | 参数1: str, ABTest配置的key 返回：str或nil                  | iOS, Android          |
| getABTestConfigValueForKeySync | 【同步】获取AB测试的配置，若不存在返回nil | 参数1: str, ABTest配置的key 返回：str或nil | iOS, Android |
| getAllAbTestConfigs | 获取ABTest相关配置，此接口不会触发曝光，可以随意读取。如果正常为了做实验，请勿使用此接口，请使用getABTestConfigValueForKey、getABTestConfigValueForKeySync接口 | 参数: 无返回：object | iOS, Android |

### 设备信息

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


## License

MIT
