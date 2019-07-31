#
# Be sure to run `pod lib lint REIAnalyticsKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'REIAnalyticsKit'
  s.version          = '0.1.0'
  s.summary          = 'Analytics for REIs mobile ecosystem.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/S0MMS/REIAnalyticsKit'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'S0MMS' => 'cshreve@rei.com' }
  s.source           = { :git => 'https://github.com/S0MMS/REIAnalyticsKit.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.source_files = 'REIAnalyticsKit/Classes/**/*'
  
  # s.resource_bundles = {
  #   'REIAnalyticsKit' => ['REIAnalyticsKit/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  s.static_framework = true
  
  #s.dependency 'ACPTargetVEC', '~> 2.0'
  #s.dependency 'ACPMobileServices', '~> 1.0'
  s.dependency 'ACPTarget', '~> 2.1'
  #s.dependency 'ACPAudience', '~> 2.0'
  s.dependency 'ACPAnalytics', '~> 2.0'
  #s.dependency 'ACPPlacesMonitor', '~> 1.0'
  s.dependency 'ACPCore', '~> 2.0'
  s.dependency 'ACPUserProfile', '~> 2.0'
  
  s.dependency 'NewRelicAgent'
  
  s.pod_target_xcconfig = { 'VALID_ARCHS' => 'arm64 x86_64 armv7' }
  
end
