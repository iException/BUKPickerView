# BUKPickerView

BUKPickerView is used for multi level data selection. Using UITableView to display each level's data,
and UITableViewCell for each item. You can set the delegate to your own class, and implement the delegate
methods for any situation.

But I think delegate is quite flexible for simple data selection, I also provide a BUKPickViewModel class.
BUKPickerViewModel's instance can directly be used as BUKPickerView's delegate, and providing ways for customize.

I wish the BUKPickerViewModel can satisfy most of your needs, or you need to write your own delegate or just 
open some issues in the github.

## Usage

Download the code, and see the sample.

## Requirements

iOS 7.0 and later.

## Installation

BUKPickerView is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "BUKPickerView"
```

## Author

hyice, hy_ice719@163.com

## License

BUKPickerView is available under the MIT license. See the LICENSE file for more info.
