source 'https://github.com/CocoaPods/Specs.git'
inhibit_all_warnings!
platform :ios, '12.0'
use_frameworks!

abstract_target 'WhimPods' do
	pod 'Alamofire', '~> 4.8'
	pod 'AlamofireNetworkActivityIndicator', '~> 2.4.0'
	pod 'RxSwift', '~> 5'
	pod 'Kingfisher', '~> 5.0'

	target 'Whim' do
		inherit! :search_paths
			
		pod 'Alamofire', '~> 4.8'
		pod 'AlamofireNetworkActivityIndicator', '~> 2.4.0'
		pod 'RxSwift', '~> 5'
		pod 'Kingfisher', '~> 5.0'
	end
    
    target 'WhimTests' do
        inherit! :search_paths
        
    end

     target 'WhimUITests' do
        inherit! :search_paths
        
    end
end
