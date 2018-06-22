# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'

target 'PhotoViewerApp' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for PhotoViewerApp
    pod 'Alamofire'
    pod 'Kingfisher'
    pod 'TinyConstraints'
    pod 'RxSwift'
    pod 'RxCocoa'
    pod 'SwiftLint'

    def testing_pods
    # Pods for testing
      pod 'RxBlocking'
      pod 'RxTest'
      pod 'Quick'
      pod 'Nimble'
      pod 'Mockingjay'
    end

  target 'PhotoViewerAppTests' do
    inherit! :search_paths
    # Pods for testing
    testing_pods
  end

  target 'PhotoViewerAppUITests' do
    inherit! :search_paths
    # Pods for testing
    testing_pods
    pod 'Alamofire'
    pod 'Kingfisher'
    pod 'TinyConstraints'
    pod 'RxSwift'
    pod 'RxCocoa'
  end

end
