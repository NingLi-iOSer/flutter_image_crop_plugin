#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'flutter_image_crop_plugin'
  s.version          = '1.1.1'
  s.summary          = 'A flutter image crop plugin.'
  s.description      = <<-DESC
A new flutter plugin project.
                       DESC
  s.homepage         = 'https://github.com/NingLi-iOSer/flutter_image_crop_plugin'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Ning' => 'lining201702@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'

  s.ios.deployment_target = '8.0'
end

