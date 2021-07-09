# react-native-mrangers-log

[![npm version](https://badge.fury.io/js/react-native-mrangers-log.svg)](https://badge.fury.io/js/react-native-mrangers-log)

此仓库基于rangers_applog_reactnative_plugin

Android SDK Version: 5.5.5

iOS SDK Version: 5.6.4

## 开始

`$ npm install react-native-mrangers-log -E`

>在使用 RangersAppLog SDK 前，你需要先[注册DataRangers账号](https://datarangers.com.cn/help/doc?lid=1867&did=40001)并且创建一个应用。


## 插件安装与初始化

### iOS

1. 打开`ios/Podfile`文件，添加以下（百川仓库）
```
require_relative '../node_modules/@react-native-community/cli-platform-ios/native_modules'
·······
source 'https://github.com/CocoaPods/Specs.git'
source 'https://github.com/bytedance/cocoapods_sdk_source_repo.git'

·······
target
```

2. 添加 rangersapplog.XXXXXXX 的UrlScheme，注意替换

### Android

1. 在 app module 的 build.gradle 并在 dependencies 中添加:

```javascript
// 在 dependencies 中添加
implementation 'com.bytedance.applog:RangersAppLog-Lite-cn:5.5.5'

```

2. 在 app module 的 build.gradle 并在 defaultConfig 中添加:

```javascript
defaultConfig {
	...
	manifestPlaceholders.put("APPLOG_SCHEME", "rangersapplog.XXXXXXXXX".toLowerCase())
}

```


## 插件接口文档

| 接口名                     | 功能                              | 参数                                                        | 支持平台     |
|----------------------------|-----------------------------------|-------------------------------------------------------------|--------------|
| setUserUniqueId            | 设置用户登录 Id                   | 参数1：string，可空。user_unique_id。                       | iOS, Android |
| setHeaderInfo              | 自定义header信息 设置用户公共属性 | 参数1：字典，可空。自定义header信息。                       | iOS, Android |
| onEventV3                  | 生成自定义埋点                    | 参数1：string，非空。事件名。 参数2：字典，可空。事件参数。 | iOS, Android |
| getDeviceID                | 获取did                   | 参数：无 返回：str。                                        | iOS, Android          |
| getAbSdkVersion            | 获取全部客户端和服务端已曝光参数  | 参数：无 返回：str                                          | iOS, Android          |
| getABTestConfigValueForKey | 获取AB测试的配置，若不存在返回nil | 参数1: str, ABTest配置的key 返回：str或nil                  | iOS, Android          |
| init | 初始化 | 参数：字典，不可空，参考index.js | iOS，Android |


## Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and the development workflow.

## License

MIT
