#
# Be sure to run `pod lib lint DGMapModule.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'DGMapModule'
  s.version          = '0.1.0'
  s.summary          = 'A short description of DGMapModule.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/Tom.Liu/DGMapModule'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Tom.Liu' => 'tomliu@yeahka.com' }
  s.source           = { :git => 'https://github.com/Tom.Liu/DGMapModule.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'DGMapModule/Classes/**/*'
  
  s.resource_bundles = {
    'DGMapModule' => ['DGMapModule/Assets/*.xcassets']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
#   s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  
  s.dependency 'AFNetworking'
#  pod 'AMap3DMap'

  s.dependency 'AMapSearch' #搜索服务SDK
  s.dependency 'AMapLocation'
  s.dependency 'AMapNavi'  #这个要放到其他高德sdk后
  s.dependency 'JZLocationConverter'#gps纠偏

  s.dependency 'MTCategoryComponent'
  s.dependency 'MTLayoutUtilityComponent'
end
