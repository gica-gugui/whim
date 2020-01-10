source 'https://github.com/CocoaPods/Specs.git'
inhibit_all_warnings!
platform :ios, '12.0'
use_frameworks!

abstract_target 'WhimPods' do
	pod 'Alamofire'	
	pod 'AlamofireNetworkActivityIndicator'
	pod 'RxSwift'
	pod 'Swinject'
	pod 'SwinjectStoryboard'

	target 'Whim' do
		inherit! :search_paths
			
		pod 'Alamofire'	
		pod 'AlamofireNetworkActivityIndicator'
		pod 'RxSwift'
		pod 'Swinject'
		pod 'SwinjectStoryboard'
	end
    
    target 'WhimTests' do
        inherit! :search_paths
        
    end

     target 'WhimUITests' do
        inherit! :search_paths
        
    end
end
