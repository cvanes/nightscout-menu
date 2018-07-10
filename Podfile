platform :osx, '10.13'
use_frameworks!
inhibit_all_warnings!

workspace 'NightscoutMenu.xcworkspace'

target 'NightscoutMenu' do
  project 'NightscoutMenu/NightscoutMenu.xcodeproj'

#  pod 'Swinject'
#  pod 'SwinjectStoryboard'
  pod 'RxSwift'
  pod 'Moya/RxSwift'

  target 'NightscoutMenuTests' do
    inherit! :search_paths
    pod 'SwiftHamcrest'
  end
end
