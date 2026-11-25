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
