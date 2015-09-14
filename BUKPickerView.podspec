#
# Be sure to run `pod lib lint BUKPickerView.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "BUKPickerView"
  s.version          = "1.0.3"
  s.summary          = "Data picker using UITableViews, allow multi level selection and multi selection."
  s.description      = <<-DESC 
                        BUKPickerView is used for multi level data selection. Using UITableView to display each level's data,
                        and UITableViewCell for each item. You can set the delegate to your own class, and implement the delegate
                        methods for any situation.

                        But I think delegate is quite flexible for simple data selection, I also provide a BUKPickViewModel class.
                        BUKPickerViewModel's instance can directly be used as BUKPickerView's delegate, and providing ways for customize.

                        I wish the BUKPickerViewModel can satisfy most of your needs, or you need to write your own delegate or just
                        open some issues in the github.
                       DESC
  s.homepage         = "https://github.com/iException/BUKPickerView"
  s.license          = 'MIT'
  s.author           = { "hyice" => "hy_ice719@163.com" }
  s.source           = { :git => "https://github.com/iException/BUKPickerView.git", :tag => s.version.to_s }

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/*'

  s.dependency 'BUKDynamicPopView', '~> 1.0.2'
end
