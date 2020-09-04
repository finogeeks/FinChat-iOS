# Uncomment this line to define a global platform for your project
platform :ios, "9.0"
source 'https://git.finogeeks.com/cocoapods/finogeeks'
source 'https://git.finogeeks.com/cocoapods/FinPods'
source 'https://github.com/CocoaPods/Specs.git'

inhibit_all_warnings!
def sharePods
    pod 'Masonry'
    pod 'ReactiveObjC'
    pod 'SVProgressHUD'
    pod 'SDWebImage'
    pod 'FinChat-Mixins','3.10.391'
	pod 'Weibo_SDK', '3.2.3'
end
def finochatPods
    pod 'Bugly','2.5.0'
end
target "FinChatDemo" do
    sharePods
    finochatPods
end
target "finshare" do 
    sharePods
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
            config.build_settings['ENABLE_STRICT_OBJC_MSGSEND'] = 'NO'
            config.build_settings['APPLICATION_EXTENSION_API_ONLY'] = 'NO'
    end
  end
end
