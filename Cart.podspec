#
# Be sure to run `pod lib lint Cart.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Cart'
  s.version          = '0.1.3'
  s.summary          = 'This is an example of cart. First view is for all products and other view is selected products in cart'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
'This is an example of cart. First view is for all products and other view is selected products in cart'
                       DESC

  s.homepage         = 'https://github.com/WaqarAhmedBajwa/Cart'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'WaqarAhmedBajwa' => 'waqarahmed.bajwa@gmail.com' }
  s.source           = { :git => 'https://github.com/WaqarAhmedBajwa/Cart.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '12.0'
  s.swift_version = '4.0'
  s.source_files = 'Source/**/*'
  s.platforms = {
      "ios": "12.0"
  }
  
  #s.resources = 'Source/Database/ShoppingCartDB.xcdatamodel'
  
   s.resource_bundles = {
     'Cart' => ['ShoppingCartDB.xcdatamodel']
   }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
