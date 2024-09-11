# Uncomment the next line to define a global platform for your project
platform :ios, '15.0'

target 'EditingOfPhotos' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  pod 'FirebaseCore'
  pod 'FirebaseAuth'
  pod 'GoogleSignIn'
  pod 'GoogleSignInSwiftSupport'
end

post_install do |installer|
   installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
    end
  end
end
