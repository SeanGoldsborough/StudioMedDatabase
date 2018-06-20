# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'
source 'https://github.com/CocoaPods/Specs.git'
target 'StudioMedDatabase' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
    pod 'JTAppleCalendar', '~> 7.0'
    pod 'Firebase/Core'
    pod 'Firebase/Database'
    pod 'Firebase/Auth'
    pod 'Firebase/Messaging'
    #    pod 'GoogleSignIn'

  # Pods for StudioMedDatabase

  target 'StudioMedDatabaseTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'StudioMedDatabaseUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end
