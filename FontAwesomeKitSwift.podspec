Pod::Spec.new do |s|
  s.name = 'FontAwesomeKitSwift'
  s.version = '0.1'
  s.homepage = 'https://github.com/Luck9Star/FontAwesomeKitSwift'
  s.authors = {
    'Luck9Star' => 'luck9Star@github.com'
  }
  s.source = { :git => 'https://github.com/Luck9Star/FontAwesomeKitSwift.git', :branch => 'master' }
  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.10'
  s.watchos.deployment_target = '2.0'
  s.source_files = 'FontAwesomeKitSwift/**/*.swift'
  s.resources = 'FontAwesomeKitSwift/**/*.{ttf,otf}'
  s.framework = 'CoreText'
end
