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


  s.source_files = "ios/**/*.{h,m,mm,swift}"


  s.dependency "React-Core"

  s.subspec "RangersAppLog" do |a|
    a.dependency "RangersAppLog/Host/CN", '6.16.6'
    a.dependency "RangersAppLog/Core", '6.16.6'
    a.dependency "RangersAppLog/Unique", '6.16.6' # 采集IDFA，如果不希望读取IDFA，可不集成
    a.dependency "RangersAppLog/Log", '6.16.6'
    a.dependency "RangersAppLog/UITracker", '6.16.6' # ⽆埋点日志采集SDK，用于无埋点事件采集
    # a.dependency "RangersAppLog/Picker", '6.16.6' # 圈选SDK，用于无埋点事件圈选
    # a.dependency "RangersAppLog/OneKit", '6.16.6'
    a.dependency "VolMetaSecML", '4.3.0.5-bugfix' #反作弊风控子库
  end
end
