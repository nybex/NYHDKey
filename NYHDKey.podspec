#
# Be sure to run `pod lib lint NAME.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = "NYHDKey"
  s.version          = "0.1.0"
  s.summary          = "A short description of NYHDKey."
  s.description      = <<-DESC
                       An optional longer description of NYHDKey

                       * Markdown format.
                       * Don't worry about the indent, we strip it!
                       DESC
  s.homepage         = "http://EXAMPLE/NAME"
  s.screenshots      = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Jud" => "Jud.Stephenson@gmail.com" }
  s.source           = { :git => "http://EXAMPLE/NAME.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/EXAMPLE'

  s.ios.deployment_target = '6.0'
  s.osx.deployment_target = '10.7'
  s.requires_arc = true

  s.source_files = 'NYHDKey/Classes', 'NYHDKey/Classes/CoreBitcoin'
  s.resources = 'NYHDKey/Assets/*.png'

  s.ios.exclude_files = 'NYHDKey/Classes/osx'
  s.osx.exclude_files = 'NYHDKey/Classes/ios'
  s.public_header_files = 'NYHDKey/Classes/**/*.h'

  s.frameworks = 'Security'

  s.dependency 'OpenSSL-Universal'
  s.dependency 'SSKeychain'
end
