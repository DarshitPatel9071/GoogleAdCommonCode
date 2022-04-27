Pod::Spec.new do |spec|

  spec.name         = "GoogleAdCommonCode"
  spec.version      = "1.0.0"
  spec.summary      = "Common Google Ad code"
  spec.description  = <<-DESC
  this pod helps you for use common google code in your peoject.
                   DESC
  spec.homepage     = "https://github.com/DarshitPatel9071/GoogleAdCommonCode"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = { "Darshit Patel" => "" }
  spec.source       = { :git => "https://github.com/DarshitPatel9071/GoogleAdCommonCode.git", :tag => "#{spec.version}" }
  spec.source_files  = 'Vasu_Common_AD_framwork/**/*.{swift}'
  spec.ios.deployment_target = '12.0'
  spec.swift_versions = "5.0"
  spec.dependency 'Google-Mobile-Ads-SDK'
  spec.dependency 'ReachabilitySwift'
  spec.static_framework = true
end

