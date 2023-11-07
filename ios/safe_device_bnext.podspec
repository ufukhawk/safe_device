#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
#
Pod::Spec.new do |s|
  s.name             = 'safe_device_bnext'
  s.version          = '1.0.0'
  s.summary          = 'Jailbroken, root, emulator and mock location detection'
  s.description      = <<-DESC
Jailbroken, root, emulator and mock location detection
                       DESC
  s.homepage         = 'https://github.com/ufukhawk/safe_device'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Ufuk Zimmerman' => 'ufukzimmerman@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'DTTJailbreakDetection'
  s.platform = :ios, '8.0'

end
