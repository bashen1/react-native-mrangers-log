require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))

Pod::Spec.new do |s|
  s.name         = "react-native-rangers-applog-reactnative-plugin"
  s.version      = package["version"]
  s.summary      = package["description"]
  s.homepage     = package["homepage"]
  s.license      = package["license"]
  s.authors      = package["author"]

  s.platforms    = { :ios => "9.0" }
  s.source       = { :git => "https://code.byted.org/iOS_Library/rangers_applog_reactnative_plugin.git", :tag => "#{s.version}" }


  s.source_files = [
    "ios/RangersAppLogModule.{h,m,mm,swift}",
    "ios/sdk/Headers/RangersAppLog/*.h",
  ]

  # 集成本地 xcframework 后，CocoaPods 会把 ios/sdk/Headers/RangersAppLog/*.h
  # 平铺到 Pods/Headers/Public/<pod>/ 下（丢失 RangersAppLog/ 层级），
  # 导致源码里的 #import <RangersAppLog/xxx.h> 找不到头文件。
  # 这里显式把 ios/sdk/Headers 加入搜索路径，使 <RangersAppLog/xxx.h> 始终
  # 从源码目录解析；RangersAppLogModule.h 仍由 Pods/Headers/Public 提供。
  s.pod_target_xcconfig = {
    "HEADER_SEARCH_PATHS" => '"${PODS_TARGET_SRCROOT}/ios/sdk/Headers"',
  }
  s.user_target_xcconfig = {
    "HEADER_SEARCH_PATHS" => '"${PODS_ROOT}/../../node_modules/react-native-mrangers-log/ios/sdk/Headers"',
  }

  s.resources    = "ios/sdk/Resources/RangersAppLog.bundle"
  s.vendored_frameworks = [
    "ios/sdk/RangersAppLogCore.xcframework",
    "ios/sdk/RangersAppLogEncryptor_VOLC.xcframework",
    "ios/sdk/RangersAppLogHost_CN.xcframework",
    "ios/sdk/RangersAppLogLog.xcframework",
    "ios/sdk/RangersAppLogUITracker.xcframework",
    "ios/sdk/RangersAppLogUnique.xcframework",
    "ios/sdk/VolcEngineEncryptor.xcframework",
  ]

  s.frameworks = "Foundation", "UIKit", "CoreGraphics", "QuartzCore", "WebKit",
                 "SystemConfiguration", "CoreTelephony", "Security", "CoreLocation",
                 "AVFoundation", "CoreMedia", "StoreKit", "JavaScriptCore",
                 "CFNetwork", "ImageIO", "CoreText", "CoreServices",
                 "SafariServices", "AdSupport"
  s.weak_frameworks = "CoreML", "AppTrackingTransparency", "Network"
  s.libraries = "z", "sqlite3"

  s.dependency "React-Core"
end
