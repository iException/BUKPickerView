//
//  BUKPickerView.h
//  Pods
//
//  Created by hyice on 15/6/30.
//
//

#import <UIKit/UIKit.h>

@protocol BUKPickerViewDataSourceAndDelegate <NSObject>

@required

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section depth:(NSInteger)depth;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath depth:(NSInteger)depth;

@optional

- (CGFloat)coverRateForTableView:(UITableView *)tableView depth:(NSInteger)depth;
- (void)registerCellClassOrNibForTableView:(UITableView *)tableView depth:(NSInteger)depth;

// Some methods in `UITableViewDataSource` and `UITableViewDelegate`, added `depth` parameter.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath depth:(NSInteger)depth;
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath depth:(NSInteger)depth;

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView depth:(NSInteger)depth;

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath depth:(NSInteger)depth;

// section header and footer
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section depth:(NSInteger)depth;
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section depth:(NSInteger)depth;

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section depth:(NSInteger)depth;
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section depth:(NSInteger)depth;

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section depth:(NSInteger)depth;
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section depth:(NSInteger)depth;
@end



@interface BUKPickerView : UIView

@property (nonatomic, strong) UIView *titleView;

@property (nonatomic, weak) id<BUKPickerViewDataSourceAndDelegate> delegate;

- (void)push;
- (BOOL)pop;

@end
