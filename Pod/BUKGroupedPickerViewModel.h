//
//  BUKGroupedPickerViewModel.h
//  Pods
//
//  Created by 李翔 on 4/14/16.
//
//

#import <Foundation/Foundation.h>
#import "BUKPickerViewModel.h"

@class BUKPickerTitleView;

@interface BUKPickerViewSection : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *titleIndex;
@property (nonatomic) NSArray<BUKPickerViewItem *> *items;

@property (nonatomic, weak) BUKPickerViewItem *parentItem;

@end

@interface BUKGroupedPickerViewModel : NSObject <BUKPickerViewDataSourceAndDelegate>

/**
 *  Default is YES, using `BUKPickerTitleView`.
 */
@property (nonatomic, assign) BOOL needTitleView;

/**
 *  Title view for picker view if `needTitleView` is set to YES.
 */
@property (nonatomic, strong, readonly) BUKPickerTitleView *titleView;

/**
 *  Displayed when lazy load block is triggered. You can custom the view
 *  by assigning a new view to this property.
 */
@property (nonatomic, strong) UIView *loadingView UI_APPEARANCE_SELECTOR;

/**
 *  Default is NO.
 */
@property (nonatomic, assign) BOOL allowMultiSelect;

/**
 *  if allowMultiSelect, total selection count should be less than this value
 */
@property (nonatomic, assign) NSInteger maxSelectionCount;

/**
 *  if user tries to over select, perform this action
 */
@property (nonatomic, copy) void(^overSelectionAction)(void);

/**
 *  Default each level share the screen equally. Such as 1.0, 0.75, 0.5, 0.25 for 4 level dataSource.
 *  If coverRates array's count if less than levels, the last rate will be used again and again.
 *
 *  @warning Item with lazyChildren will lead default rates to wrong rates. Also, only last item's level
 *  will be considered.
 */
@property (nonatomic, strong) NSArray *coverRates;

/**
 *  Default cell title can only be one line. Set this flag to YES to enable multi line title feature.
 */
@property (nonatomic, assign) BOOL enableMultiLineTitleForCell;


// Custom Cell UI
@property (nonatomic, strong) UIColor *oddLevelCellNormalTextColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *oddLevelCellNormalBgColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *oddLevelCellHighlightTextColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *oddLevelCellHighlightBgColor UI_APPEARANCE_SELECTOR;

@property (nonatomic, strong) UIColor *evenLevelCellNormalTextColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *evenLevelCellNormalBgColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *evenLevelCellHighlightTextColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *evenLevelCellHighlightBgColor UI_APPEARANCE_SELECTOR;

- (instancetype)initWithPickerViewSections:(NSArray<BUKPickerViewSection *> *)sections
                                  complete:(void (^)(id result))complete;
- (instancetype)initWithLazyPickerViewSections:(void (^)(BUKFinishLoadPickerViewItemsBlock))lazyLoad complete:(void (^)(id))complete;

@end
