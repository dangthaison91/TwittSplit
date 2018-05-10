# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'

# Comment the next line if you're not using Swift and don't want to use dynamic frameworks
use_frameworks!
inhibit_all_warnings!

def shared_pods
 
    #Database
    pod 'RealmSwift'
    
    #Reactive
    # pod 'Action'
    pod 'RxSwift'
    pod 'RxCocoa'
    pod 'RxDataSources'
    pod 'RxRealm'
    pod 'RxSwiftExt'
    pod 'RxOptional'

    #UI
    pod 'KMPlaceholderTextView'
    
    # Tool
    pod 'SwiftDate'
    pod 'SwiftGen'
    pod 'SwiftLint'
end


target 'TwittSplit' do
  shared_pods
end

 target 'TwittSplitTests' do
    inherit! :search_paths
 end

 post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            if config.name == 'Debug'
                config.build_settings['OTHER_SWIFT_FLAGS'] = ['$(inherited)', '-Onone']
                config.build_settings['SWIFT_OPTIMIZATION_LEVEL'] = '-Owholemodule'
            end
        end
    end
end


