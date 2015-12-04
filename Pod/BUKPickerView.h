//
//  BUKPickerView.h
//  Pods
//
//  Created by hyice on 15/6/30.
//
//

#import <UIKit/UIKit.h>
#import <BUKDynamicPopView/BUKDynamicPopView.h>

@class BUKPickerView;

@protocol BUKPickerViewDataSourceAndDelegate <NSObject>

@required

- (NSInteger)buk_tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section depth:(NSInteger)depth pickerView:(BUKPickerView *)pickerView;
- (UITableViewCell *)buk_tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath depth:(NSInteger)depth pickerView:(BUKPickerView *)pickerView;

@optional

- (void)buk_pickerView:(BUKPickerView *)pickerView didFinishPushToDepth:(NSInteger)depth;
- (void)buk_pickerView:(BUKPickerView *)pickerView didFinishPopToDepth:(NSInteger)depth;

- (CGFloat)buk_coverRateForTableView:(UITableView *)tableView depth:(NSInteger)depth pickerView:(BUKPickerView *)pickerView;
- (void)buk_registerCellClassOrNibForTableView:(UITableView *)tableView depth:(NSInteger)depth pickerView:(BUKPickerView *)pickerView;

// Some methods in `UITableViewDataSource` and `UITableViewDelegate`, added `depth` parameter.
- (void)buk_tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath depth:(NSInteger)depth pickerView:(BUKPickerView *)pickerView;
- (void)buk_tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath depth:(NSInteger)depth pickerView:(BUKPickerView *)pickerView;

- (NSInteger)buk_numberOfSectionsInTableView:(UITableView *)tableView depth:(NSInteger)depth pickerView:(BUKPickerView *)pickerView;

- (CGFloat)buk_tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath depth:(NSInteger)depth pickerView:(BUKPickerView *)pickerView;

// section header and footer
- (CGFloat)buk_tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section depth:(NSInteger)depth pickerView:(BUKPickerView *)pickerView;
- (CGFloat)buk_tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section depth:(NSInteger)depth pickerView:(BUKPickerView *)pickerView;

- (NSString *)buk_tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section depth:(NSInteger)depth pickerView:(BUKPickerView *)pickerView;
- (NSString *)buk_tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section depth:(NSInteger)depth pickerView:(BUKPickerView *)pickerView;

- (UIView *)buk_tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section depth:(NSInteger)depth pickerView:(BUKPickerView *)pickerView;
- (UIView *)buk_tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section depth:(NSInteger)depth pickerView:(BUKPickerView *)pickerView;

@end


/**
 *  BUKPickerView is used for multi level data selection. Using UITableView to display each level's data,
 *  and UITableViewCell for each item. You can set the delegate to your own class, and implement the delegate
 *  methods for any situation.
 *
 *  But I think delegate is quite flexible for simple data selection, I also provide a BUKPickViewModel class.
 *  BUKPickerViewModel's instance can directly be used as BUKPickerView's delegate, and providing ways for customize.
 *
 *  I wish the BUKPickerViewModel can satisfy most of your needs, or you need to write your own delegate or just 
 *  open some issues in the github.
 */
@interface BUKPickerView : UIView

/**
 *  TitleView default is nil. You can setup the titleView with any view. Make sure to set the frame.size.height
 *  before assign the view to the titleView property, or default height 44 will be used.
 */
@property (nonatomic, strong) UIView *titleView;

- (instancetype)initWithDelegate:(id<BUKPickerViewDataSourceAndDelegate>)delegate;

- (BOOL)push;
- (BOOL)pop;

/**
 *  @param depth start from 0
 */
- (BOOL)popToDepth:(NSInteger)depth;

- (UITableView *)tableViewAtDepth:(NSInteger)depth;

@end
