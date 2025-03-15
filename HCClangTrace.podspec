#
# Be sure to run `pod lib lint HCClangTrace.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'HCClangTrace'
  s.version          = '1.1.0'
  s.summary          = 'A tool to trace methods and generate orderFile.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Use Clang Trace all method include c、oc、swift and block，you can use this tool to generate orderFile that gather
almost all the method that your app called.
                       DESC

  s.homepage         = 'https://github.com/jayhe/HCClangTrace'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'jay.he' => '1054134542@qq.com' }
  s.source           = { :git => 'https://github.com/jayhe/HCClangTrace.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'HCClangTrace/Classes/**/*'
  
  # s.resource_bundles = {
  #   'HCClangTrace' => ['HCClangTrace/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
