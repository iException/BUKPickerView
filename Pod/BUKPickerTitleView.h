//
//  BUKPickerTitleView.h
//  Pods
//
//  Created by hyice on 15/8/6.
//
//

#import <UIKit/UIKit.h>

@class BUKPickerTitleView;

typedef void (^BUKPickerTitleViewAction) (BUKPickerTitleView *titleView);

@interface BUKPickerTitleView : UIView

@property (nonatomic, strong, readonly) UIButton *leftButton;
@property (nonatomic, strong, readonly) UIButton *rightButton;
@property (nonatomic, strong, readonly) UILabel *titleLabel;
@property (nonatomic, strong, readonly) UIView *bottomLine;


@property (nonatomic, copy) BUKPickerTitleViewAction leftButtonAction;
@property (nonatomic, copy) BUKPickerTitleViewAction rightButtonAction;



// Custom UI

@property (nonatomic, strong) UIColor *titleColor UI_APPEARANCE_SELECTOR;

/**
 *  Color used for left and right button's normal state color.
 */
@property (nonatomic, strong) UIColor *tintColor UI_APPEARANCE_SELECTOR;

@property (nonatomic, strong) UIColor *bottomLineColor UI_APPEARANCE_SELECTOR;
@end
