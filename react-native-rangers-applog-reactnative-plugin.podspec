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

  s.subspec "Core" do |a|
    a.dependency "RangersAppLog/Core", "5.6.4"
    a.dependency "RangersAppLog/Host/CN", "5.6.4"
    a.dependency "RangersAppLog/Log", "5.6.4"
  end
end
