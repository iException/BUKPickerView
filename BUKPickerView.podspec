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
  s.version          = "1.0.0"
  s.summary          = "Data picker using UITableViews, allow multi level selection and multi selection."
  s.description      = <<-DESC 
                       Data picker using UITableViews, allow multi level selection and multi selection. You
                       can simply use it.
                       DESC
  s.homepage         = "https://github.com/iException/BUKPickerView"
  s.license          = 'MIT'
  s.author           = { "hyice" => "hy_ice719@163.com" }
  s.source           = { :git => "https://github.com/iException/BUKPickerView.git", :tag => s.version.to_s }

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/*'

  s.dependency 'BUKDynamicPopView', '~> 1.0.0'
end
