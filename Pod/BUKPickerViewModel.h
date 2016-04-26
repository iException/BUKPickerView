//
//  BUKPickerViewModel.h
//  Pods
//
//  Created by hyice on 15/8/6.
//
//

#import <Foundation/Foundation.h>
#import "BUKPickerView.h"

typedef void (^BUKFinishLoadPickerViewItemsBlock)(NSArray *bukPickerViewItems);

@class BUKPickerTitleView;

@interface BUKPickerViewItem : NSObject

/**
 *  Title used to display in the cell.
 */
@property (nonatomic, copy) NSString *title;

/**
 *  Image to display for each item, default is nil.
 */
@property (nonatomic, strong) UIImage *image;

/**
 *  Children items for next level. If the children is async fetched(such as a url request), you can
 *  lazy load the children use `lazyChildren` instead of this.
 *
 *  @warning If `children` is set, property `lazyChildren` will be discarded.
 */
@property (nonatomic, strong) NSArray *children;

/**
 *  Lazy load children for next level. Block will be involved when this item is selected, and goto
 *  next level when children is returned by the block. Block will be involved only once, property
 *  `children` will be set after block returned.
 *
 *  If you pass an empty array as children, the parent item will be directly selected.
 *  If you pass nil as children, this will be considered as a loading error.
 *
 *  @warning If `children` is set, property `lazyChildren` will be discarded.
 */
@property (nonatomic, copy) void (^lazyChildren)(BUKFinishLoadPickerViewItemsBlock complete);

/**
 *  Selection state for item. If item has `children` set, next level will be load
 *  in single selection mode, otherwhise this flag will be discarded.
 */
@property (nonatomic, assign) BOOL isSelected;


// @optional properties for custom Usage, not required.
/**
 *  Not Required, just left for your need. You can store things which you want to upload or use later.
 */
@property (nonatomic, strong) id selectValue;

/**
 * Not Required, you can set this property and retreive the whole selection path.
 */
@property (nonatomic, weak) BUKPickerViewItem *parent;


@end



@class BUKPickerViewModel;

@protocol BUKPickerViewModelDelegate <NSObject>

@optional;
- (void)buk_pickerViewModel:(BUKPickerViewModel *)model didSelectItem:(BUKPickerViewItem *)item;
- (void)buk_pickerViewModel:(BUKPickerViewModel *)model didDeselectItem:(BUKPickerViewItem *)item;

@end





@interface BUKPickerViewModel : NSObject <BUKPickerViewDataSourceAndDelegate>

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

// selection result
@property (nonatomic, readonly) NSArray<BUKPickerViewItem *> *selectionResult;

// delegate
@property (nonatomic, weak) id<BUKPickerViewModelDelegate> delegate;


/**
 *  Initialize a BUKPickerViewModel, which is used as BUKPickerView's delegate.
 *
 *  @param items    NSArray consist of BUKPickerViewItems.
 *  @param complete Block will be involved when selection finished. If property `allowMultiSelect`
 *  is not set to YES, then block will be involved when item which doesn't have children and lazyChildren
 *  is selected. The parameter `result` will be an `BUKPickerViewItem`. If property `allowMultiSelect` is
 *  set to YES, then block will be involved when the right button in the title view be pressed. The parameter
 *  `result` will be an array of `BUKPickerViewItem`s.
 */
- (instancetype)initWithPickerViewItems:(NSArray<BUKPickerViewItem *> *)items
                               complete:(void (^)(id result))complete;

/**
 *  Same as -initWithPickerViewItems:complete:, only make it possible for lazy load.
 */
- (instancetype)initWithLazyPickerViewItems:(void (^)(BUKFinishLoadPickerViewItemsBlock finishLoad))lazyLoad
                                   complete:(void (^)(id result))complete;


- (void)deselectItem:(BUKPickerViewItem *)item;

@end
