#
# Be sure to run `pod lib lint ServiceApi.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ServiceApi'
  s.version          = '0.5.0'
  s.summary          = 'Abstract Api for interaction with REST service.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Implement facade pattern for hide interaction with network service by AFNetworking from clients
                       DESC

  s.homepage         = 'https://github.com/star-s/ServiceApi'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Sergey Starukhin' => 'star.s@me.com' }
  s.source           = { :git => 'https://github.com/star-s/ServiceApi.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.9'
  s.watchos.deployment_target = '2.0'
  s.tvos.deployment_target = '9.0'

  s.source_files = 'ServiceApi/Classes/**/*'
  
  # s.resource_bundles = {
  #   'ServiceApi' => ['ServiceApi/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.public_header_files = 'ServiceApi/Classes/Public/*.h'
  s.private_header_files = 'ServiceApi/Classes/Private/*.h'
  s.module_map = 'ServiceApi/ServiceApi.modulemap'
  s.dependency 'AFNetworking', '~> 3.0'
end
