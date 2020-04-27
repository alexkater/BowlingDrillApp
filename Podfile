# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'BowlingDrilling' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  enable_bitcode_for_prebuilt_frameworks!
  keep_source_code_for_prebuilt_frameworks!
  all_binary!

  # Pods for testing
  pod 'Firebase/Database'
  pod 'Firebase/Auth'
  # Functional reactive programming library used across all app.
  # - https://github.com/ReactiveCocoa/ReactiveCocoa
  pod 'ReactiveCocoa', '10.0.0'
  pod 'Giphy'
  pod 'IQKeyboardManagerSwift'
  pod 'NVActivityIndicatorView'

  # Pods for BowlingDrilling

  target 'BowlingDrillingTests' do
    inherit! :search_paths
    pod 'Nimble', '8.0.1'
    pod 'Quick', '2.0.0'
  end

end
