#
# Be sure to run `pod lib lint WebServer.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "WebServer"
  s.version          = "0.1.0"
  s.summary          = "winchance's WebServer"
  s.description      = <<-DESC
                       An optional longer description of WebServer

                       * Markdown format.
                       * Don't worry about the indent, we strip it!
                       DESC
  s.homepage         = "https://github.com/guoshencheng/WebServer.git"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "guoshencheng" => "648772021@qq.com" }
  s.source           = { :git => "https://github.com/guoshencheng/WebServer.git", :tag => s.version.to_s }
  # s.social_media_url = 'guoshencheng.github.io'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'WebServer' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
    s.dependency 'AFNetworking', '~> 2.5.4'
end
