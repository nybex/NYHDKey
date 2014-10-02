#
# Be sure to run `pod lib lint NAME.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = "NYHDKey"
  s.version          = "0.3.0"
  s.summary          = "Useful wrapper around CoreBitcoin's HD Key implimentation"
  s.description      = <<-DESC
                       Useful wrapper around CoreBitcoin's HD Key implimentation
                       DESC
  s.homepage         = "https://github.com/nybex/NYHDKey"
  s.license          = 'MIT'
  s.author           = { "Jud" => "Jud.Stephenson@gmail.com" }
  s.source           = { :git => "https://github.com/nybex/NYHDKey.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/JudStephenson'

  s.ios.deployment_target = '6.0'
  s.osx.deployment_target = '10.7'
  s.requires_arc = true

  s.source_files = 'NYHDKey/Classes'
  s.public_header_files = 'NYHDKey/Classes/**/*.h'

  s.frameworks = 'Security'

  s.dependency 'CoreBitcoin'
end
