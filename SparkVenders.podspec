#
# Be sure to run `pod lib lint SparkVenders.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SparkVenders'
  s.version          = '0.1.0'
  s.summary          = 'A short description of SparkVenders.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/SparkeXHApp/SparkVenders'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'SparkeXHApp' => 'sfhery@foxmail.com' }
  s.source           = { :git => 'https://github.com/SparkeXHApp/SparkVenders.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.source_files = 'SparkVenders/Classes/**/*'
  
  # s.resource_bundles = {
  #   'SparkVenders' => ['SparkVenders/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  
  s.dependency 'ASIHTTPRequest'
  s.dependency 'SDCycleScrollView'
  s.dependency 'SnapKit'
  s.dependency 'TZImagePickerController'
  s.dependency 'SensorsAnalyticsSDK/Core'
  s.dependency 'SensorsAnalyticsSDK/Exception'
  s.dependency 'SensorsAnalyticsSDK/Exposure'
  s.dependency 'SDWebImage', '4.4.8'
  
  s.subspec 'FJDeepSleepPreventer' do |ss|
      ss.source_files = 'AppVenders/Classes/FJDeepSleepPreventer/**/*'
      ss.resource_bundles = {
            'FJDeepSleepPreventer' => ['AppVenders/Assets/FJDeepSleepPreventer/*.wav'],
        }
  end
  
  s.subspec 'XLPhotoBrowser+CoderXL' do |ss|
      ss.source_files = 'AppVenders/Classes/XLPhotoBrowser+CoderXL/**/*'
      ss.resource_bundles = {
            'XLPhotoBrowser+CoderXL' => ['AppVenders/Assets/XLPhotoBrowser+CoderXL/*.png'],
        }
  end
  
  s.subspec 'RSKImageCropper' do |ss|
      ss.source_files = 'AppVenders/Classes/RSKImageCropper/**/*'
      ss.resource_bundles = {
            'RSKImageCropper' => ['AppVenders/Assets/RSKImageCropper/*.bundle'],
        }
  end
  
  s.subspec 'SPEUploadPhoto' do |ss|
      ss.source_files = 'AppVenders/Classes/SPEUploadPhoto/**/*'
      ss.resource_bundles = {
            'SPEUploadPhoto' => ['AppVenders/Assets/SPEUploadPhoto/*.xib'],
        }
  end
  
  s.subspec 'ZLPhotoLib' do |ss|
      ss.source_files = 'AppVenders/Classes/ZLPhotoLib/**/*'
      ss.resource_bundles = {
            'ZLPhotoLib' => ['AppVenders/Assets/ZLPhotoLib/*.bundle'],
        }
  end
  
end
