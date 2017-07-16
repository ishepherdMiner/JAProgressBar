Pod::Spec.new do |s|
  s.name         = "JAProgressBar"
  s.version      = "0.0.3"
  s.summary      = "A progress bar that track the network request"
  s.description  = <<-DESC
  A progress bar that track the network request.
  Supports WKWebView, UIWebView and NSURLSession
                   DESC
  s.homepage     = "https://github.com/ishepherdMiner/JAProgressBar"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"
  s.license      = "MIT"
  s.author       = { "Jason" => "iJason92@yahoo.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/ishepherdMiner/JAProgressBar.git", :tag => "#{s.version}" }
  s.source_files = "JAProgressBar", "JAProgressBar/**/*.{h,m}"  

  s.public_header_files = "JAProgressBar/**/*.h"
  s.frameworks   = "UIKit", "QuartzCore","Foundation"
  s.requires_arc = true
  s.module_name  = "JAProgressBar"
  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  s.dependency "AFNetworking" 

end
